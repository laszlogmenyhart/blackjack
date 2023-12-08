namespace play {
    internal class Program {

        static int countScore(int N, string[] arr) {
            int[] values = new int[N];
            for (int i = 0; i < N; i++) {
                values[i] = Int32.Parse(arr[i].Split(";")[2]);
            }
            Array.Sort(values);
            int sum = 0;
            for (int i = 0; i < N; i++) {
                int x = values[i];
                if ((x == 11) && (sum + x > 21)) {
                    sum += 1;
                } else {
                    sum += x;
                }
            }
            return sum;
        }

        static int finalScore(int score) {
            if (score > 21) {
                return 0;
            } else {
                return score;
            }
        }

        static void showCards(string title, int N, string[] X) {
            Console.Write(title + " : [");
            for (int i = 0; i < N; i++) {
                if (i > 0) {
                    Console.Write(",");
                }
                Console.Write("\"" + X[i] + "\"");
            }
            Console.WriteLine("]");
        }

        static void getACard(ref int handN, ref string[] hand, ref int swappedDOCN, ref string[] swappedDOC) {
            hand[handN] = swappedDOC[0];
            handN++;
            swappedDOCN--;
            for (int i = 0; i < swappedDOCN; i++) {
                swappedDOC[i] = swappedDOC[i + 1];
            }
        }

        static void Main(string[] args) {
            Console.WriteLine("Blackjack");

            /// declaration
            /// 
            int N = 52;
            int swappedDOCN = N;
            string[] swappedDOC;

            string blackjackResult;

            /// read input data
            /// 
            /*
            string[] swappedDOC = new string[N];
            for (int i = 0; i < 52; i++) {
                swappedDOC[i] = Console.ReadLine();
            }
            */
            swappedDOC = File.ReadAllLines("deckOfCards.txt");

            /// solve the problem - implement algorithms
            /// 
			/*
            int Na;
            int Nb;
            string[] a = new string[N];
            string[] b = new string[N];
            Random rand = new Random();
            for (int i=1;i<=20;i++) {
                int vel=rand.Next(0,52);
                for (int j=0;j<vel;j++) {
                    a[j] = swappedDOC[j];
                }
                Na = vel;
                for (int j=vel;j<N;j++) {
                    b[j-vel] = swappedDOC[j];
                }
                Nb = N - Na;

                int ia = 0;
                int ib = 0;
                int ii = 0;
                while ((ia <Na) || (ib <Nb)) {
                    if ((ia < Na) && (ib < Nb)) {
                        if (rand.Next(0, 100)<50) {
                            swappedDOC[ii] = a[ia];
                            ii++;
                            ia++;
                        } else {
                            swappedDOC[ii] = b[ib];
                            ii++;
                            ib++;
                        }
                    } else {
                        for (int j=ia;j<Na;j++) {
                            swappedDOC[ii] = a[ia];
                            ii++;
                            ia++;
                        }
                        for (int j = ib; j < Nb; j++) {
                            swappedDOC[ii] = b[ib];
                            ii++;
                            ib++;
                        }
                    }
                }
            }
			*/
            Random rand = new Random();
            for (int i = 1; i <= 100; i++) {
                int vel = rand.Next(0, 52);
                int ia = 0;
                int ib = vel;
                int ii = 0;
                while ((ia < vel) && (ib < N)) {
                    if (rand.Next(0, 100) < 50) {
                        ii++;
                        ia++;
                    } else {
                        string tmp = swappedDOC[ib];
                        swappedDOC[ib] = swappedDOC[ii];
                        swappedDOC[ii] = tmp;
                        ii++;
                        ib++;
                    }
                }
            }
            // showCards("Swapped cards", swappedDOCN, swappedDOC);

            int bankN = 0;
            string[] bank = new string[N];
            int playerN = 0;
            string[] player = new string[N];

            getACard(ref playerN, ref player, ref swappedDOCN, ref swappedDOC);
            getACard(ref bankN, ref bank, ref swappedDOCN, ref swappedDOC);
            showCards("You can see this card at Bank", bankN, bank);
            Console.WriteLine("  Score: " + countScore(bankN, bank));
            getACard(ref playerN, ref player, ref swappedDOCN, ref swappedDOC);
            getACard(ref bankN, ref bank, ref swappedDOCN, ref swappedDOC);

            string val;
            do {
                int sz = countScore(playerN, player);
                showCards("Cards of Player", playerN, player);
                Console.WriteLine("  Total score: " + sz);
                if (sz > 21) {
                    val = "n";
                } else {
                    Console.Write("Do you hit one more card? (y/N):");
                    val = Console.ReadLine();
                }
                if (val == "y") {
                    getACard(ref playerN, ref player, ref swappedDOCN, ref swappedDOC);
                }
            } while (val == "y");

            while (countScore(bankN, bank) < 17)
            {
                getACard(ref bankN, ref bank, ref swappedDOCN, ref swappedDOC);
            }

            int playerScore = countScore(playerN, player);
            int bankScore = countScore(bankN, bank);

            int playerScoreFinal = finalScore(playerScore);
            int bankScoreFinal = finalScore(bankScore);

            if ((playerScoreFinal == 21) && (bankScoreFinal < 21)) {
                blackjackResult = "BLACKJACK Win - 3:2";
            } else if ((playerScoreFinal == bankScoreFinal) && (playerScoreFinal > 0)) {
                blackjackResult = "PUSH Get back - 1:1";
            } else if (playerScoreFinal > bankScoreFinal) {
                blackjackResult = "BUST Win - 2:1";
            } else {
                blackjackResult = "YOU LOST - 0:1";
            }

            /// write out answers
            /// 
            showCards("Cards of Player", playerN, player);
            Console.WriteLine("  Total score: " + playerScore + ", final score: " + playerScoreFinal);

            showCards("Cards of Bank", bankN, bank);
            Console.WriteLine("  Total score: " + bankScore + ", final score: " + bankScoreFinal);
            Console.WriteLine(blackjackResult);
        }
    }
}