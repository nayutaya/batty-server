
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.IO;
using System.Net;

namespace batty_agent
{
    public partial class Form1 : Form
    {
        private bool tick = true;

        public Form1()
        {
            InitializeComponent();
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
            //this.Send();
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
            request.Timeout = 5 * 1000;
            
            return request;
        }

        private void Send()
        {
            string deviceToken = this.tokenTextBox.Text;

            WebRequest request = this.CreateUpdateRequest(deviceToken, "0");

            try
            {
                using ( WebResponse response = request.GetResponse() )
                {
                    this.debugLabel.Text = "OK";
                }
            }
            catch ( Exception ex )
            {
                this.debugLabel.Text = ex.GetType().Name + ": " + ex.Message;
            }
        }

        private void startButton_Click(object sender, EventArgs e)
        {
            timer1.Enabled = true;
        }

        private void stopButton_Click(object sender, EventArgs e)
        {
            timer1.Enabled = false;
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            this.tick = !this.tick;

            this.tickPanel.BackColor = (this.tick ? Color.Red : Color.Green);

            this.AddLog("自動送信");
        }
    }
}
