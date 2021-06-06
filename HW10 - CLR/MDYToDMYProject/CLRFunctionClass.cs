using Microsoft.Analytics.Interfaces;
using Microsoft.Analytics.Interfaces.Streaming;
using Microsoft.Analytics.Types.Sql;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Collections;
using System.Data.SqlClient;
using Microsoft.SqlServer.Server;
using System.Text.RegularExpressions;
using System.Data.SqlTypes;

namespace MDYToDMYProject
{
    public class ClrFunction
    {
        [SqlFunction(
            Name = "MDYToDMY",
            IsDeterministic = false)]
        public static string MDYToDMY(String input)
        {
            try
            {
                return Regex.Replace(input,
                       @"\b(?<month>\d{1,2})/(?<day>\d{1,2})/(?<year>\d{2,4})\b",
                      "${day}-${month}-${year}", RegexOptions.None,
                      TimeSpan.FromMilliseconds(150));
            }
            catch (RegexMatchTimeoutException)
            {
                return input;
            }
        }
    }
}