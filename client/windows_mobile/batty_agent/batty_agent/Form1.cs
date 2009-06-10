
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace batty_agent
{
    public partial class Form1 : Form
    {
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
    }
}
