
using System;
using System.Collections.Generic;
using System.Text;

namespace winbattery1
{
    class Program
    {
        static void Main(string[] args)
        {
            //Battery battery = new Battery();
            Battery.BatteryCollection bc = Battery.GetInstances();
            foreach ( Battery b in bc )
            {
                Console.WriteLine(b.EstimatedChargeRemaining);
            }

            Console.WriteLine(System.Windows.Forms.SystemInformation.PowerStatus);
        }
    }
}

