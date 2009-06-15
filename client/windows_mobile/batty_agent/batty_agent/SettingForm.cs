
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

        public SettingForm()
        {
            InitializeComponent();
        }

        public void LoadFrom(Setting setting)
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
            this.sendOnCountComboBox.Text = setting.SendOnCountRecord.ToString();
            this.sendOnLevelChangeCheckBox.Checked = setting.SendOnChangeBatteryState;
            this.sendOnChargeChangeCheckBox.Checked = setting.SendOnChangeChargeState;
        }

        public void SaveTo(Setting setting)
        {
            // [基本]タブ
            setting.DeviceToken = this.tokenTextBox.Text;

            // [記録]タブ
            setting.EnableRecordOnBatteryCharging = this.recordOnChargeCheckBox.Checked;
            setting.EnableRecordOnPowerConnecting = this.recordOnAcConnectCheckBox.Checked;

            // [記録タイミング]タブ
            setting.RecordOnInterval = this.recordOnIntervalCheckBox.Checked;
            setting.RecordOnIntervalMinute = uint.Parse(this.recordOnIntervalComboBox.Text);
            setting.RecordOnChangeLevelState = this.recordOnLevelChangeCheckBox.Checked;
            setting.RecordOnChangeChargeState = this.recordOnChargeChangeCheckBox.Checked;

            // [送信タイミング]タブ
            setting.SendOnInterval = this.sendOnIntervalCheckBox.Checked;
            setting.SendOnIntervalMinute = uint.Parse(this.sendOnIntervalComboBox.Text);
            setting.SendOnCount = this.sendOnCountCheckBox.Checked;
            setting.SendOnCountRecord = uint.Parse(this.sendOnCountComboBox.Text);
            setting.SendOnChangeBatteryState = this.sendOnLevelChangeCheckBox.Checked;
            setting.SendOnChangeChargeState = this.sendOnChargeChangeCheckBox.Checked;
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

        private void SettingForm_Load(object sender, EventArgs e)
        {
            this.UpdateGeneralTab();
            this.UpdateRecordTab();
            this.UpdateRecordTimingTab();
            this.UpdateSendTimingTab();
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
