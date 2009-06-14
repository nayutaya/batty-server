
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Text.RegularExpressions;

namespace nayutaya.batty.agent
{
    public partial class SettingForm : Form
    {
        private readonly Regex tokenPattern = new Regex(@"\A[0-9a-f]{20}\z");
        private Setting setting = new Setting();

        public SettingForm()
        {
            InitializeComponent();

            this.setting.DeviceToken = "hoge";
            this.setting.EnableRecordOnBatteryCharging = false;
            this.setting.EnableRecordOnPowerConnecting = true;
            this.setting.RecordOnInterval = false;
            this.setting.RecordOnIntervalMinute = 10;
            this.setting.RecordOnChangeLevelState = true;
            this.setting.RecordOnChangeChargeState = false;
            this.setting.SendOnInterval = true;
            this.setting.SendOnIntervalMinute = 15;
            this.setting.SendOnCount = false;
            this.setting.SendOnCountRecords = 30;
            this.setting.SendOnChangeBatteryState = true;
            this.setting.SendOnChangeChargeState = false;

            this.LoadFrom(setting);
            this.UpdateGeneralTab();
            this.UpdateRecordTab();
            this.UpdateRecordTimingTab();
            this.UpdateSendTimingTab();
        }

        private void LoadFrom(Setting setting)
        {
            // [基本]タブ
            this.tokenTextBox.Text = setting.DeviceToken;

            // [記録]タブ
            this.recordOnChargeCheckBox.Checked = setting.EnableRecordOnBatteryCharging;
            this.recordOnAcConnectCheckBox.Checked = setting.EnableRecordOnPowerConnecting;

            // [記録タイミング]タブ
            this.recordOnIntervalCheckBox.Checked = setting.RecordOnInterval;
            this.recordOnIntervalComboBox.Text = setting.RecordOnIntervalMinute.ToString();
            this.recordOnLevelChangeCheckBox.Checked = setting.RecordOnChangeLevelState;
            this.recordOnChargeChangeCheckBox.Checked = setting.RecordOnChangeChargeState;

            // [送信タイミング]タブ
            this.sendOnIntervalCheckBox.Checked = setting.SendOnInterval;
            this.sendOnIntervalComboBox.Text = setting.SendOnIntervalMinute.ToString();
            this.sendOnCountCheckBox.Checked = setting.SendOnCount;
            this.sendOnCountComboBox.Text = setting.SendOnCountRecords.ToString();
            this.sendOnLevelChangeCheckBox.Checked = setting.SendOnChangeBatteryState;
            this.sendOnChargeChangeCheckBox.Checked = setting.SendOnChangeChargeState;
        }

        private void UpdateGeneralTab()
        {
            bool isValidToken = tokenPattern.IsMatch(this.tokenTextBox.Text);
            this.invalidTokenLabel.Visible = !isValidToken;
            this.validTokenLabel.Visible = isValidToken;
        }

        private void UpdateRecordTab()
        {
            // nop
        }

        private void UpdateRecordTimingTab()
        {
            this.recordOnIntervalComboBox.Enabled = this.recordOnIntervalCheckBox.Checked;
        }

        private void UpdateSendTimingTab()
        {
            this.sendOnIntervalComboBox.Enabled = this.sendOnIntervalCheckBox.Checked;
            this.sendOnCountComboBox.Enabled = this.sendOnCountCheckBox.Checked;
        }

        private void tokenTextBox_TextChanged(object sender, EventArgs e)
        {
            this.UpdateGeneralTab();
        }

        private void recordOnIntervalCheckBox_CheckStateChanged(object sender, EventArgs e)
        {
            this.UpdateRecordTimingTab();
        }

        private void sendOnIntervalCheckBox_CheckStateChanged(object sender, EventArgs e)
        {
            this.UpdateSendTimingTab();
        }

        private void sendOnCountCheckBox_CheckStateChanged(object sender, EventArgs e)
        {
            this.UpdateSendTimingTab();
        }
    }
}
