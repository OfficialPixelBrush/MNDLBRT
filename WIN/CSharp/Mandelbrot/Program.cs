using System;

namespace Mandelbrot
{
    class Program
    {
        static double mapRange(double a1, double a2, double b1, double b2, double s)
        {
            return b1 + (s - a1) * (b2 - b1) / (a2 - a1);
        }

        static void Main(string[] args) {
            char empty = '░';
            char bg = '▒';
            char fill = '█';
            int segmentCollumn = 4;
            int segmentRow = 2;
            int xSize = segmentCollumn*5;
            int ySize = segmentRow*8;//Convert.ToInt32(xSize);///2.25);
            while (true) {
                int iterations = 1;
                Console.Write("x Koordinate: ");
                double xCoord = Convert.ToDouble(Console.ReadLine());
                Console.Write("y Koordinate: ");
                double yCoord = Convert.ToDouble(Console.ReadLine());
                Console.Write("Zoom: ");
                double Zoom = Convert.ToDouble(Console.ReadLine());

                double aspect = ((double)xSize) / ((double)ySize);
                for (int y = 0; y < ySize; y++) {
                    if (y % 8 == 0) {
                        for (int x = 0; x < xSize+(xSize/5)+1; x++) {
                            Console.Write(empty);
                        }
                        Console.Write("\n");
                    }
                    for (int x = 0; x < xSize; x++) {
                        if (x % 5 == 0) {
                            Console.Write(empty);
                        }
                        int i;
                        double cx = mapRange(0, xSize, xCoord + (-2*aspect) * Zoom, xCoord + (2 * aspect) * Zoom, x);
                        double cy = mapRange(0, ySize, yCoord + 2 * Zoom, yCoord + -2 * Zoom, y);
                        double zx = cx;
                        double zy = cy;

                        for (i = 0; i < iterations; i++) {
                            double tmp = zx;
                            zx = (zx * zx - zy * zy + cx);
                            zy = 2 * tmp * zy + cy;
                            if ((zx * zx + zy * zy) > 4)
                            {
                                Console.Write(bg);
                                /*switch (i % 6) {
                                    case 0:
                                        Console.Write("░");
                                        break;
                                    case 1:
                                        Console.Write("▒");
                                        break;
                                    case 2:
                                        Console.Write("▓");
                                        break;
                                    case 3:
                                        Console.Write("█");
                                        break;
                                    case 4:
                                        Console.Write("▓");
                                        break;
                                    case 5:
                                        Console.Write("▒");
                                        break;
                                }*/
                                break;
                            }
                        }
                        if (i == iterations) {
                            Console.Write(fill);
                        }
                    }
                    Console.Write(empty);
                    Console.Write("\n");
                }
                for (int x = 0; x < xSize + (xSize / 5) + 1; x++) {
                    Console.Write(empty);
                }
                Console.Write("\n");
            }
        }
    }
}
