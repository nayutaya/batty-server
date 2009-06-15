
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
        }

        public void Save(Setting setting)
        {
            OpenNETCF.AppSettings.SettingsFile settingFile = this.CreateSettingsFile();
            
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
            this.SaveValue(settingFile, "SendTiming", "SendOnCountRecords", setting.SendOnCountRecords);
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

        private OpenNETCF.AppSettings.SettingsFile CreateSettingsFile()
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
    }
}
