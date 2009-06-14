
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
        private Regex tokenPattern = new Regex(@"\A[0-9a-f]{20}\z");

        public SettingForm()
        {
            InitializeComponent();

            this.UpdateGeneralTab();
            this.UpdateRecordTab();
            this.UpdateRecordTimingTab();
            this.UpdateSendTimingTab();
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
