
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.IO;
using System.Net;

namespace nayutaya.batty.agent
{
    public partial class MainForm : Form
    {
        private bool tick = true;
        private uint min = 0;

        public MainForm()
        {
            InitializeComponent();

            System.Reflection.Module m = System.Reflection.Assembly.GetExecutingAssembly().ManifestModule;
            string dir = System.IO.Path.GetDirectoryName(m.FullyQualifiedName);
            string file = dir + @"\token.txt";

            if ( File.Exists(file) )
            {
                using ( StreamReader st = new StreamReader(file) )
                {
                    this.tokenTextBox.Text = st.ReadToEnd();
                }
            }
        }

        private void exitButton_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        private void showCurrentLevelButton_Click(object sender, EventArgs e)
        {
            BatteryStatus bs = new BatteryStatus();
            this.currentLevelLabel.Text = (bs.LifePercent.HasValue ? bs.LifePercent.ToString() + " %" : "不明");
            this.currentChargingLabel.Text = (bs.Charging.HasValue ? (bs.Charging.Value ? "はい" : "いいえ") : "不明");
            this.currentLineLabel.Text = (bs.PowerLineConnecting.HasValue ? (bs.PowerLineConnecting.Value ? "はい" : "いいえ") : "不明");
        }

        private void AddLog(string message)
        {
            DateTime dt = DateTime.Now;

            ListViewItem lvi = new ListViewItem();
            lvi.Text = dt.ToString("hh:mm:ss");
            lvi.SubItems.Add(message);

            this.listView1.Items.Insert(0, lvi);

            while ( this.listView1.Items.Count > 10 )
            {
                this.listView1.Items.RemoveAt(10);
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
            if ( bs.PowerLineConnecting.Value )
            {
                this.AddLog("電源接続中です");
                return false;
            }
            if ( !bs.Charging.HasValue )
            {
                this.AddLog("充電状態が不明です");
                return false;
            }
            if ( bs.Charging.Value )
            {
                this.AddLog("充電中です");
                return false;
            }
            if ( !bs.LifePercent.HasValue )
            {
                this.AddLog("バッテリレベルが不明です");
                return false;
            }

            string deviceToken = this.tokenTextBox.Text;
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

        private void startButton_Click(object sender, EventArgs e)
        {
            timer1.Interval = 60 * 1000;
            timer1.Enabled = true;
            this.AddLog("開始しました");
        }

        private void stopButton_Click(object sender, EventArgs e)
        {
            timer1.Enabled = false;
            this.AddLog("停止しました");
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            this.tick = !this.tick;
            this.tickPanel.BackColor = (this.tick ? Color.Red : Color.Green);

            this.min += 1;

            if ( this.min >= 5 )
            {
                this.min = 0;
                this.AddLog("自動送信");
                this.Send();
            }
        }
    }
}
