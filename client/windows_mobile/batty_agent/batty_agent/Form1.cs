
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
            this.currentStatusLabel.Text = (bs.Charging.HasValue ? ("充電中: " + (bs.Charging.Value ? "はい" : "いいえ")) : "-");
            this.currentLevelLabel.Text = (bs.LifePercent.HasValue ? bs.LifePercent.ToString() + " %" : "-");
        }
    }
}
