
using System;
using System.Collections.Generic;
using System.Text;

namespace nayutaya.batty.agent
{
    class Setting
    {
        private String deviceToken;
        private bool enableRecordOnBatteryCharging;
        private bool enableRecordOnPowerConnecting;
        private bool recordOnInterval;
        private uint recordOnIntervalMinute;
        private bool recordOnChangeLevelState;
        private bool recordOnChangeChargeState;
        private bool sendOnInterval;
        private uint sendOnIntervalMinute;
        private bool sendOnCount;
        private uint sendOnCountRecords;
        private bool sendOnChangeBatteryState;
        private bool sendOnChangeChargeState;

        public String DeviceToken
        {
            get { return deviceToken; }
            set { deviceToken = value; }
        }
    }
}
