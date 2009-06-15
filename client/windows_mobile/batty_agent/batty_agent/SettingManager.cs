
using System;
using System.Collections.Generic;
using System.Text;

namespace nayutaya.batty.agent
{
    public class SettingManager
    {
        private readonly string filepath;

        public SettingManager()
        {
            this.filepath = this.GetExecutingAssemblyDirectoryPath() + @"\setting.xml";
        }

        public void Load(Setting setting)
        {
            OpenNETCF.AppSettings.SettingsFile settingFile = this.GetSettingsFile();

            setting.DeviceToken = (string)this.LoadValue(settingFile, "General", "DeviceToken", "");

            setting.EnableRecordOnBatteryCharging = (bool)this.LoadValue(settingFile, "Record", "EnableRecordOnBatteryCharging", true);
            setting.EnableRecordOnPowerConnecting = (bool)this.LoadValue(settingFile, "Record", "EnableRecordOnPowerConnecting", true);

            setting.RecordOnInterval = (bool)this.LoadValue(settingFile, "RecordTiming", "RecordOnInterval", true);
            setting.RecordOnIntervalMinute = (uint)this.LoadValue(settingFile, "RecordTiming", "RecordOnIntervalMinute", 10U);
            setting.RecordOnChangeLevelState = (bool)this.LoadValue(settingFile, "RecordTiming", "RecordOnChangeLevelState", false);
            setting.RecordOnChangeChargeState = (bool)this.LoadValue(settingFile, "RecordTiming", "RecordOnChangeChargeState", false);

            setting.SendOnInterval = (bool)this.LoadValue(settingFile, "SendTiming", "SendOnInterval", false);
            setting.SendOnIntervalMinute = (uint)this.LoadValue(settingFile, "SendTiming", "SendOnIntervalMinute", 10U);
            setting.SendOnCount = (bool)this.LoadValue(settingFile, "SendTiming", "SendOnCount", true);
            setting.SendOnCountRecord = (uint)this.LoadValue(settingFile, "SendTiming", "SendOnCountRecord", 1U);
            setting.SendOnChangeBatteryState = (bool)this.LoadValue(settingFile, "SendTiming", "SendOnChangeBatteryState", false);
            setting.SendOnChangeChargeState = (bool)this.LoadValue(settingFile, "SendTiming", "SendOnChangeChargeState", false);
        }

        public void Save(Setting setting)
        {
            OpenNETCF.AppSettings.SettingsFile settingFile = this.GetSettingsFile();
            
            this.SaveValue(settingFile, "General", "DeviceToken", setting.DeviceToken);

            this.SaveValue(settingFile, "Record", "EnableRecordOnBatteryCharging", setting.EnableRecordOnBatteryCharging);
            this.SaveValue(settingFile, "Record", "EnableRecordOnPowerConnecting", setting.EnableRecordOnPowerConnecting);

            this.SaveValue(settingFile, "RecordTiming", "RecordOnInterval", setting.RecordOnInterval);
            this.SaveValue(settingFile, "RecordTiming", "RecordOnIntervalMinute", setting.RecordOnIntervalMinute);
            this.SaveValue(settingFile, "RecordTiming", "RecordOnChangeLevelState", setting.RecordOnChangeLevelState);
            this.SaveValue(settingFile, "RecordTiming", "RecordOnChangeChargeState", setting.RecordOnChangeChargeState);

            this.SaveValue(settingFile, "SendTiming", "SendOnInterval", setting.SendOnInterval);
            this.SaveValue(settingFile, "SendTiming", "SendOnIntervalMinute", setting.SendOnIntervalMinute);
            this.SaveValue(settingFile, "SendTiming", "SendOnCount", setting.SendOnCount);
            this.SaveValue(settingFile, "SendTiming", "SendOnCountRecord", setting.SendOnCountRecord);
            this.SaveValue(settingFile, "SendTiming", "SendOnChangeBatteryState", setting.SendOnChangeBatteryState);
            this.SaveValue(settingFile, "SendTiming", "SendOnChangeChargeState", setting.SendOnChangeChargeState);

            settingFile.Save();
        }

        private string GetExecutingAssemblyFilePath()
        {
            return System.Reflection.Assembly.GetExecutingAssembly().ManifestModule.FullyQualifiedName;
        }

        private string GetExecutingAssemblyDirectoryPath()
        {
            return System.IO.Path.GetDirectoryName(this.GetExecutingAssemblyFilePath());
        }

        private OpenNETCF.AppSettings.SettingsFile GetSettingsFile()
        {
            return new OpenNETCF.AppSettings.SettingsFile(this.filepath);
        }

        private OpenNETCF.AppSettings.SettingGroup GetGroup(OpenNETCF.AppSettings.SettingsFile settingFile, string groupName)
        {
            if ( !settingFile.Groups.Contains(groupName) )
            {
                settingFile.Groups.Add(groupName);
            }
            return settingFile.Groups[groupName];
        }

        private void SaveValue(OpenNETCF.AppSettings.SettingsFile settingFile, string groupName, string key, object value)
        {
            OpenNETCF.AppSettings.Setting setting = this.GetGroup(settingFile, groupName).Settings[key];
            setting.Value = value;
        }

        private object LoadValue(OpenNETCF.AppSettings.SettingsFile settingFile, string groupName, string key, object defaultValue)
        {
            OpenNETCF.AppSettings.Setting setting = this.GetGroup(settingFile, groupName).Settings[key];
            return (setting.Value != null ? setting.Value : defaultValue);
        }
    }
}
