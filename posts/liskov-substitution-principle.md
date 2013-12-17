title: Liskov Substitution Principle
author: rexim
date: Sun, 15 Dec 2013 23:44:17 +0700

<!-- OMG, markdown sucks! -->
<img src="images/LSP.png" style="float: left; width: 50%; margin-right: 20px;" />

The most mysterious [SOLID](http://en.wikipedia.org/wiki/SOLID)
principle for me was always the third one. The
[Liskov Substitution Principle](http://en.wikipedia.org/wiki/Liskov_substitution_principle)
(LSP). I knew that classical example with deriving Square from
Rectangle, but I didn't understand why it is violation of LSP.

The principle has a pretty simple idea. When we define a class we
define more than just a set of methods and fields. We have also a set
of assumptions (or properties) between these methods and fields. For
example, we have a class with the following method:

    class Date {
      ...
      def getMonthNumber(): Int
      ...
    }

This method must return an integer. And the assumption above this
method is the integer should be between 1 and 12. So the idea of LSP
is the subtype of the class should derive both the method and
assumption. It is important because then the class can be safely
replaced by the subclass without violation correctness of the program.

    import java.io.*;
    import java.util.*;

    public class Main {

        void solve() throws IOException {
            int n = nextInt();

            double R = nextDouble();
            double r = nextDouble();

            if(n > 1) {
                double beta = 2 * Math.PI / n;
                double a = R - r;
                // double b = a * Math.sqrt(2.0 * (1.0 - Math.cos(beta)));
                double b = 2.0 * a * Math.sin(beta / 2.0);

                if(b > 2.0 * r || Math.abs(b - 2.0 * r) < 1e-6)
                    out.println("YES");
                else
                    out.println("NO");
            } else {
                if(R > r || Math.abs(R - r) < 1e-6)
                    out.println("YES");
                else
                    out.println("NO");
            }
        }

        void run() throws IOException {
            in = new BufferedReader(new InputStreamReader(System.in));
            out = System.out;
            solve();
            in.close();
            //out.close();
        }

        BufferedReader in;
        PrintStream out;
        StringTokenizer tok;

        void take() throws IOException {
            tok = new StringTokenizer(in.readLine());
        }

        String nextToken() throws IOException {
            while(tok == null || !tok.hasMoreTokens())
                take();

            return tok.nextToken();
        }

        int nextInt() throws IOException {
            return Integer.parseInt(nextToken());
        }

        long nextLong() throws IOException {
            return Long.parseLong(nextToken());
        }

        double nextDouble() throws IOException {
            return Double.parseDouble(nextToken());
        }

        public static void main(String[] args) throws IOException {
            new Main().run();
        }
    }
    --------------------------------------------------------------------------------

That's it!
