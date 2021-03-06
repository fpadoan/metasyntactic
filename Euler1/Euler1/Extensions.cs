﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Numerics;
using System.Collections.Concurrent;

namespace Euler
{
    public static class Extensions
    {
        public static BigInteger Sum(this IEnumerable<BigInteger> e)
        {
            BigInteger result = 0;
            foreach (var v in e)
            {
                result += v;
            }
            return result;
        }

        public static BigInteger sqrt(this BigInteger N)
        {
            BigInteger rootN = N;
            int count = 0;
            int bitLength = 1;
            while (rootN / 2 != 0)
            {
                rootN /= 2;
                bitLength++;
            }
            bitLength = (bitLength + 1) / 2;
            rootN = N >> bitLength;

            BigInteger lastRoot = BigInteger.Zero;
            do
            {
                if (lastRoot > rootN)
                {
                    if (count++ > 1000)
                    {
                        return rootN;
                    }
                }
                lastRoot = rootN;
                rootN = (BigInteger.Divide(N, rootN) + rootN) >> 1;
            }
            while ((rootN ^ lastRoot) != BigInteger.Zero);
            return rootN;
        }

        public static BigInteger factorial(this int i)
        {
            return factorial((BigInteger)i);
        }

        static ConcurrentDictionary<BigInteger, BigInteger> factorialMap =
            new ConcurrentDictionary<BigInteger, BigInteger>();

        public static BigInteger factorial(this BigInteger v)
        {
            BigInteger result = factorialMap.GetOrAdd(v,
                x => factorialWorker(v));
            return result;
        }

        public static BigInteger factorialWorker(this BigInteger v)
        {
            if (v <= 1)
            {
                return 1;
            }
            return v * factorial(v - 1);
        }

        public static BigInteger nthPower(this int i, int exponent)
        {
            return nthPower((BigInteger)i, exponent);
        }

        public static BigInteger nthPower(this BigInteger value, int exponent)
        {
            BigInteger result = BigInteger.One;

            for (int i = 0; i < exponent; i++)
            {
                result *= value;
            }

            return result;
        }

        public static bool isPalindrome(this int v)
        {
            return isPalindrome(v, 10);
        }

        public static bool isPalindrome(this int v, int base_)
        {
            return isPalindrome(Convert.ToString(v, base_));
        }

        public static bool isPalindrome(this string s)
        {
            for (int i = 0; i < s.Length / 2; i++)
            {
                if (s[i] != s[s.Length - 1 - i])
                {
                    return false;
                }
            }
            return true;
        }

        public static int digitToInt(this char c)
        {
            if (c >= '0' && c <= '9')
            {
                return c - '0';
            }

            throw new Exception();
        }

        public static string permute(this string current, int count)
        {
            if (current.Length == 0)
            {
                return "";
            }

            int f = (int)(current.Length - 1).factorial();
            char c = current[count / f];

            var sub = new String(current.Where(x => x != c).ToArray());

            return c + permute(sub, count % f);
        }

        public static String lastNSubstring(this String value, int count)
        {
            int position = Math.Max(0, value.Length - count);
            return value.Substring(position);
        }

        public static BigInteger choose(this int n, int r)
        {
            return n.factorial() / (r.factorial() * (n - r).factorial());
        }
    }
}