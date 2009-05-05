
using System;
using System.Collections.Generic;
using System.Text;
using System.Net;
using System.IO;

namespace win_http1
{
    class Program
    {
        static void Main(string[] args)
        {
            string url = "http://localhost:3000/device/0123456789abcdef/energies/update/100/20090424115121";
            WebRequest req = WebRequest.Create(url);
            req.Method = "POST";
            req.ContentType = "application/x-www-form-urlencoded";
            req.ContentLength = 0;
            try
            {
                WebResponse rsp = req.GetResponse();

                Stream stm = rsp.GetResponseStream();
                if ( stm != null )
                {
                    StreamReader reader = new StreamReader(stm, System.Text.Encoding.GetEncoding("Shift_JIS"));
                    Console.WriteLine(reader.ReadToEnd());
                    stm.Close();
                }
                rsp.Close();
            }
            catch ( WebException e )
            {
                Console.WriteLine("exception!");
                Console.WriteLine(e.Message);
            }
        }
    }
}
