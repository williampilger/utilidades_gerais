using System;

namespace cs
{
	public class Teste
    {
		private void teste_divisao_multiplicacao()
		{
			int x, y, n = 500;
			Console.WriteLine(String.Format("\n\n\nIniciando Teste de DIVISAO E MULTIPLICACAO, em C++"));
			var stopwatch = new System.Diagnostics.Stopwatch();
			stopwatch.Start();
			x = n;
			int i, j, k, z = 0;
			for (i = 0; i < n; i++)
			{
				for (j = 0; j < n; j++)
				{
					for (k = 0; k < n; k++)
					{
						y = x;
						x *= x;
						x = x / y;
						z++;
					}
				}
			}
			stopwatch.Stop();
			Console.WriteLine(String.Format("\n{0} Repeticoes\n Em {1} ms", z, stopwatch.ElapsedMilliseconds));
		}
		private void teste_comparacao_strings()
		{
			int x, y, n = 500;
			Console.WriteLine(String.Format("\n\n\nIniciando Teste de COMPARACAO DE STRINGS, em C++"));
			var stopwatch = new System.Diagnostics.Stopwatch();
			stopwatch.Start();
			string teste1 = "este é um exemplo de string simples";
			string teste2 = "esta é uma forma de testar as strings";
			string teste3 = "esta";
			string teste4 = "string";
			int i, j, k, z = 0;
			for (i = 0; i < n; i++)
			{
				for (j = 0; j < n; j++)
				{
					for (k = 0; k < n; k++)
					{
						teste1 += teste2;
						teste2 += teste3;
						teste3 += teste4;
						teste4 += teste1;
						z++;
					}
				}
			}
			stopwatch.Stop();
			Console.WriteLine(String.Format("\n{0} Repeticoes\n Em {1} ms", z, stopwatch.ElapsedMilliseconds));
		}
		private void teste_matematica_avancada()
		{
			int x = 54, n = 500;
			Console.WriteLine(String.Format("\n\n\nIniciando Teste de MATEMATICA AVANCADA, em C++"));
			var stopwatch = new System.Diagnostics.Stopwatch();
			stopwatch.Start();
			int i, j, k, z = 0;
			double traa;
			double var1 = 9871528;
			double var2 = 52525;
			double var3 = 9871527;
			double var4 = 52523;
			for (i = 0; i < n; i++)
			{
				for (j = 0; j < n; j++)
				{
					for (k = 0; k < n; k++)
					{
						traa = Math.Pow(Math.Sqrt(Math.Pow(x, 100)), 1 / 100) + var1 * var2 - var3 * var4;
						z++;
					}
				}
			}
			stopwatch.Stop();
			Console.WriteLine(String.Format("\n{0} Repeticoes\n Em {1} ms", z, stopwatch.ElapsedMilliseconds));
		}
		public void testenow()
        {
			var stopwatch = new System.Diagnostics.Stopwatch();
			stopwatch.Start();
			teste_divisao_multiplicacao();
			teste_matematica_avancada();
			teste_comparacao_strings();
			stopwatch.Stop();
			Console.WriteLine(String.Format("\n Testes todos concluidos.\n Em {1} ms", stopwatch.ElapsedMilliseconds));
		}
	}
}


