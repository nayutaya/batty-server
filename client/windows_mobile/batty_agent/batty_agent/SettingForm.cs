
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
        private readonly Regex deviceTokenPattern = new Regex(@"\A[0-9a-f]{20}\z");

        public SettingForm()
        {
            InitializeComponent();
        }

        public void LoadFrom(Setting setting)
        {
            // [基本]タブ
            this.deviceTokenTextBox.Text = setting.DeviceToken;

            // [記録]タブ
            this.enableRecordOnBatteryChargingCheckBox.Checked = setting.EnableRecordOnBatteryCharging;
            this.enableRecordOnPowerConnectingCheckBox.Checked = setting.EnableRecordOnPowerConnecting;

            // [記録タイミング]タブ
            this.recordOnIntervalCheckBox.Checked = setting.RecordOnInterval;
            this.recordOnIntervalMinuteComboBox.Text = setting.RecordOnIntervalMinute.ToString();
            this.recordOnChangeLevelStateCheckBox.Checked = setting.RecordOnChangeLevelState;
            this.recordOnChangeChargeStateCheckBox.Checked = setting.RecordOnChangeChargeState;

            // [送信タイミング]タブ
            this.sendOnIntervalCheckBox.Checked = setting.SendOnInterval;
            this.sendOnIntervalMinuteComboBox.Text = setting.SendOnIntervalMinute.ToString();
            this.sendOnCountCheckBox.Checked = setting.SendOnCount;
            this.sendOnCountRecordComboBox.Text = setting.SendOnCountRecord.ToString();
            this.sendOnChangeBatteryStateCheckBox.Checked = setting.SendOnChangeBatteryState;
            this.sendOnChangeChargeStateCheckBox.Checked = setting.SendOnChangeChargeState;
        }

        public void SaveTo(Setting setting)
        {
            // [基本]タブ
            setting.DeviceToken = this.deviceTokenTextBox.Text;

            // [記録]タブ
            setting.EnableRecordOnBatteryCharging = this.enableRecordOnBatteryChargingCheckBox.Checked;
            setting.EnableRecordOnPowerConnecting = this.enableRecordOnPowerConnectingCheckBox.Checked;

            // [記録タイミング]タブ
            setting.RecordOnInterval = this.recordOnIntervalCheckBox.Checked;
            setting.RecordOnIntervalMinute = uint.Parse(this.recordOnIntervalMinuteComboBox.Text);
            setting.RecordOnChangeLevelState = this.recordOnChangeLevelStateCheckBox.Checked;
            setting.RecordOnChangeChargeState = this.recordOnChangeChargeStateCheckBox.Checked;

            // [送信タイミング]タブ
            setting.SendOnInterval = this.sendOnIntervalCheckBox.Checked;
            setting.SendOnIntervalMinute = uint.Parse(this.sendOnIntervalMinuteComboBox.Text);
            setting.SendOnCount = this.sendOnCountCheckBox.Checked;
            setting.SendOnCountRecord = uint.Parse(this.sendOnCountRecordComboBox.Text);
            setting.SendOnChangeBatteryState = this.sendOnChangeBatteryStateCheckBox.Checked;
            setting.SendOnChangeChargeState = this.sendOnChangeChargeStateCheckBox.Checked;
        }

        private void UpdateGeneralTab()
        {
            bool isValidToken = deviceTokenPattern.IsMatch(this.deviceTokenTextBox.Text);
            this.invalidTokenLabel.Visible = !isValidToken;
            this.validTokenLabel.Visible = isValidToken;
        }

        private void UpdateRecordTab()
        {
            // nop
        }

        private void UpdateRecordTimingTab()
        {
            this.recordOnIntervalMinuteComboBox.Enabled = this.recordOnIntervalCheckBox.Checked;
        }

        private void UpdateSendTimingTab()
        {
            this.sendOnIntervalMinuteComboBox.Enabled = this.sendOnIntervalCheckBox.Checked;
            this.sendOnCountRecordComboBox.Enabled = this.sendOnCountCheckBox.Checked;
        }

        private void SettingForm_Load(object sender, EventArgs e)
        {
            this.UpdateGeneralTab();
            this.UpdateRecordTab();
            this.UpdateRecordTimingTab();
            this.UpdateSendTimingTab();
        }

        private void deviceTokenTextBox_TextChanged(object sender, EventArgs e)
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
