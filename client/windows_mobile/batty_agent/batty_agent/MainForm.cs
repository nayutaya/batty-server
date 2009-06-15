
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.IO;
using System.Net;
using Microsoft.WindowsMobile.Status;

namespace nayutaya.batty.agent
{
    public partial class MainForm : Form
    {
        private SystemState timeState = new SystemState(SystemProperty.Time);
        private SystemState batteryModeState = new SystemState(SystemProperty.PowerBatteryState);
        private SystemState batteryStrengthState = new SystemState(SystemProperty.PowerBatteryStrength);
        private DateTime lastUpdate = DateTime.Now;
        private Setting setting = new Setting();

        public MainForm()
        {
            InitializeComponent();

            this.LoadSetting();
            this.SetupSystemStates();
        }

        private void LoadSetting()
        {
            SettingManager settingManager = new SettingManager();
            settingManager.Load(this.setting);
        }

        private void SetupSystemStates()
        {
            this.timeState.Changed += new ChangeEventHandler(timeState_Changed);
            this.batteryModeState.Changed += new ChangeEventHandler(batteryModeState_Changed);
            this.batteryStrengthState.Changed += new ChangeEventHandler(batteryStrengthState_Changed);
        }

        private void timeState_Changed(object sender, ChangeEventArgs args)
        {
            DateTime now = DateTime.Now;
            DateTime nextUpdate = this.lastUpdate.AddMinutes(this.setting.RecordOnIntervalMinute).AddSeconds(-30);
            if ( now >= nextUpdate )
            {
                this.AddLog(String.Format("{0}分経過しました", this.setting.RecordOnIntervalMinute));
                this.lastUpdate = now;
                this.Send();
            }
        }

        void batteryModeState_Changed(object sender, ChangeEventArgs args)
        {
            this.AddLog("電源/充電状態が変化しました");
            this.lastUpdate = DateTime.Now;
            this.Send();
        }

        void batteryStrengthState_Changed(object sender, ChangeEventArgs args)
        {
            this.AddLog("バッテリレベルが変化しました");
            this.lastUpdate = DateTime.Now;
            this.Send();
        }

        private void exitButton_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        private void showCurrentLevelButton_Click(object sender, EventArgs e)
        {
            BatteryStatus battery = new BatteryStatus();
            this.AddLog("バッテリ残量: " + (battery.LifePercent.HasValue ? battery.LifePercent.ToString() + " %" : "不明"));
            this.AddLog("充電中: " + (battery.Charging.HasValue ? (battery.Charging.Value ? "はい" : "いいえ") : "不明"));
            this.AddLog("電源接続中: " + (battery.PowerLineConnecting.HasValue ? (battery.PowerLineConnecting.Value ? "はい" : "いいえ") : "不明"));
        }

        private void AddLog(string message)
        {
            DateTime dt = DateTime.Now;

            ListViewItem lvi = new ListViewItem();
            lvi.Text = dt.ToString("hh:mm:ss");
            lvi.SubItems.Add(message);

            this.listView1.Items.Insert(0, lvi);

            while ( this.listView1.Items.Count > 20 )
            {
                this.listView1.Items.RemoveAt(20);
            }
        }

        private void sendButton_Click(object sender, EventArgs e)
        {
            this.AddLog("手動送信");
            this.Send();
        }

        private string CreateUpdateUrl(string deviceToken, string level)
        {
            string host = "batty.nayutaya.jp";
            string path = "http://" + host + "/device/token/" + deviceToken + "/energies/update";
            return path + "/" + level;
        }

        private WebRequest CreateUpdateRequest(string deviceToken, string level)
        {
            string url = this.CreateUpdateUrl(deviceToken, level);
            WebRequest request = WebRequest.Create(url);
            request.Method = "POST";
            request.Timeout = 20 * 1000;
            
            return request;
        }

        private bool Send()
        {
            BatteryStatus bs = new BatteryStatus();

            if ( !bs.PowerLineConnecting.HasValue )
            {
                this.AddLog("電源状態が不明です");
                return false;
            }
            /*
            if ( bs.PowerLineConnecting.Value )
            {
                this.AddLog("電源接続中です");
                return false;
            }
             */
            if ( !bs.Charging.HasValue )
            {
                this.AddLog("充電状態が不明です");
                return false;
            }
            /*
            if ( bs.Charging.Value )
            {
                this.AddLog("充電中です");
                return false;
            }
             */
            if ( !bs.LifePercent.HasValue )
            {
                this.AddLog("バッテリレベルが不明です");
                return false;
            }

            string deviceToken = this.setting.DeviceToken;
            string level = bs.LifePercent.ToString();

            WebRequest request = this.CreateUpdateRequest(deviceToken, level);

            try
            {
                using ( WebResponse response = request.GetResponse() )
                {
                    this.AddLog("送信しました");
                    return true;
                }
            }
            catch ( Exception ex )
            {
                this.AddLog(ex.GetType().Name + ": " + ex.Message);
                return false;
            }
        }

        private void settingButton_Click(object sender, EventArgs e)
        {
            SettingForm form = new SettingForm();
            form.LoadFrom(this.setting);
            form.ShowDialog();
            form.SaveTo(this.setting);

            SettingManager settingManager = new SettingManager();
            settingManager.Save(this.setting);
        }
    }
}
