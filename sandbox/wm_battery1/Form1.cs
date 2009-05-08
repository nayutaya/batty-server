using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Runtime.InteropServices;

namespace wm_battery1
{
    public partial class Form1 : Form
    {
        [StructLayout(LayoutKind.Sequential)]
        struct _SYSTEM_POWER_STATUS_EX2
        {
            public byte ACLineStatus;
            public byte BatteryFlag;
            public byte BatteryLifePercent;
            public byte Reserved1;
            public uint BatteryLifeTime;
            public uint BatteryFullLifeTime;
            public byte Reserved2;
            public byte BackupBatteryFlag;
            public byte BackupBatteryLifePercent;
            public byte Reserved3;
            public uint BackupBatteryLifeTime;
            public uint BackupBatteryFullLifeTime;
            public uint BatteryVoltage;
            public uint BatteryCurrent;
            public uint BatteryAverageCurrent;
            public uint BatteryAverageInterval;
            public uint BatterymAHourConsumed;
            public uint BatteryTemperature;
            public uint BackupBatteryVoltage;
            public byte BatteryChemistry;
        }

        class win32API
        {
            // Win32API‚ÌDll‚Ì’è‹`
            [DllImport("COREDLL.dll")]
            private extern static void GetSystemPowerStatusEx2(out _SYSTEM_POWER_STATUS_EX2 pSystemPowerStatusEx2, uint dwLen, bool fUpdate);

            static _SYSTEM_POWER_STATUS_EX2 SystemPowerStatusEx2;

            public void getBatteryStatus()
            {
                uint sizeof_SystemPowerStatusEx2;
                // unsafe
                unsafe
                {
                    sizeof_SystemPowerStatusEx2 = (uint)sizeof(_SYSTEM_POWER_STATUS_EX2);
                }
                // Call Win32API
                GetSystemPowerStatusEx2(out SystemPowerStatusEx2, sizeof_SystemPowerStatusEx2, true);

            }

            public byte ACLineStatus
            {
                get
                {
                    return SystemPowerStatusEx2.ACLineStatus;
                }
            }

            public byte BatteryFlag
            {
                get
                {
                    return SystemPowerStatusEx2.BatteryFlag;
                }
            }

            public byte BatteryLifePercent
            {
                get
                {
                    return SystemPowerStatusEx2.BatteryLifePercent;
                }
            }

            public uint BatteryLifeTime
            {
                get
                {
                    return SystemPowerStatusEx2.BatteryLifeTime;
                }
            }
        }
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            win32API w = new win32API();
            w.getBatteryStatus();

            this.button1.Text = w.BatteryLifePercent.ToString();
        }
    }
}