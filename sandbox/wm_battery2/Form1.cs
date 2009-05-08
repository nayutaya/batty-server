
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using Microsoft.WindowsMobile.Status;

namespace wm_battery2
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            BatteryState bs = SystemState.PowerBatteryState;
            BatteryLevel bl = SystemState.PowerBatteryStrength;
            this.button1.Text = bl.ToString();
        }
    }
}