
using System;
using System.Collections.Generic;
using System.Text;
using System.Runtime.InteropServices;

namespace nayutaya.batty.agent
{
    class BatteryStatus
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

        private const byte AC_LINE_OFFLINE = 0;
        private const byte BATTERY_FLAG_CHARGING = 8;

        [DllImport("coredll.dll")]
        private extern static uint GetSystemPowerStatusEx2(out _SYSTEM_POWER_STATUS_EX2 pSystemPowerStatusEx2, uint dwLen, bool fUpdate);

        private bool? powerLineConnecting = null;
        private bool? charging = null;
        private byte? lifePercent = null;

        public BatteryStatus()
        {
            _SYSTEM_POWER_STATUS_EX2 status;
            uint size = 0;

            unsafe
            {
                size = (uint)sizeof(_SYSTEM_POWER_STATUS_EX2);
            }

            uint ret = GetSystemPowerStatusEx2(out status, size, true);
            if ( ret > 0 )
            {
                this.powerLineConnecting = (status.ACLineStatus != AC_LINE_OFFLINE);
                this.charging = ((status.BatteryFlag & BATTERY_FLAG_CHARGING) > 0);
                this.lifePercent = (status.BatteryLifePercent >= 0 && status.BatteryLifePercent <= 100 ? (byte?)status.BatteryLifePercent : null);
            }
        }

        public bool? PowerLineConnecting
        {
            get { return this.powerLineConnecting; }
        }

        public bool? Charging
        {
            get { return this.charging; }
        }

        public byte? LifePercent
        {
            get { return this.lifePercent; }
        }
    }
}
