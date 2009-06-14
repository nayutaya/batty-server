namespace nayutaya.batty.agent
{
    partial class SettingForm
    {
        /// <summary>
        /// 必要なデザイナ変数です。
        /// </summary>
        private System.ComponentModel.IContainer components = null;
        private System.Windows.Forms.MainMenu mainMenu1;

        /// <summary>
        /// 使用中のリソースをすべてクリーンアップします。
        /// </summary>
        /// <param name="disposing">マネージ リソースが破棄される場合 true、破棄されない場合は false です。</param>
        protected override void Dispose(bool disposing)
        {
            if ( disposing && (components != null) )
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows フォーム デザイナで生成されたコード

        /// <summary>
        /// デザイナ サポートに必要なメソッドです。このメソッドの内容を
        /// コード エディタで変更しないでください。
        /// </summary>
        private void InitializeComponent()
        {
            this.mainMenu1 = new System.Windows.Forms.MainMenu();
            this.settingTab = new System.Windows.Forms.TabControl();
            this.recordTimingTabPage = new System.Windows.Forms.TabPage();
            this.sendTimingTabPage = new System.Windows.Forms.TabPage();
            this.label1 = new System.Windows.Forms.Label();
            this.recordOnIntervalCheckBox = new System.Windows.Forms.CheckBox();
            this.recordOnIntervalComboBox = new System.Windows.Forms.ComboBox();
            this.label2 = new System.Windows.Forms.Label();
            this.recordOnChargeChangeCheckBox = new System.Windows.Forms.CheckBox();
            this.recordOnLevelChangeCheckBox = new System.Windows.Forms.CheckBox();
            this.panel1 = new System.Windows.Forms.Panel();
            this.label3 = new System.Windows.Forms.Label();
            this.sendOnIntervalCheckBox = new System.Windows.Forms.CheckBox();
            this.sendOnIntervalComboBox = new System.Windows.Forms.ComboBox();
            this.label4 = new System.Windows.Forms.Label();
            this.panel2 = new System.Windows.Forms.Panel();
            this.sendOnCountCheckBox = new System.Windows.Forms.CheckBox();
            this.sendOnCountComboBox = new System.Windows.Forms.ComboBox();
            this.label5 = new System.Windows.Forms.Label();
            this.sendOnLevelChangeCheckBox = new System.Windows.Forms.CheckBox();
            this.sendOnChargeChangeCheckBox = new System.Windows.Forms.CheckBox();
            this.panel3 = new System.Windows.Forms.Panel();
            this.panel4 = new System.Windows.Forms.Panel();
            this.panel5 = new System.Windows.Forms.Panel();
            this.generalTabPage = new System.Windows.Forms.TabPage();
            this.label6 = new System.Windows.Forms.Label();
            this.tokenTextBox = new System.Windows.Forms.TextBox();
            this.recordTabPage = new System.Windows.Forms.TabPage();
            this.noRecordOnChargeCheckBox = new System.Windows.Forms.CheckBox();
            this.noRecordOnAcConnectCheckBox = new System.Windows.Forms.CheckBox();
            this.invalidTokenLabel = new System.Windows.Forms.Label();
            this.validTokenLabel = new System.Windows.Forms.Label();
            this.settingTab.SuspendLayout();
            this.recordTimingTabPage.SuspendLayout();
            this.sendTimingTabPage.SuspendLayout();
            this.panel1.SuspendLayout();
            this.panel2.SuspendLayout();
            this.panel3.SuspendLayout();
            this.panel4.SuspendLayout();
            this.panel5.SuspendLayout();
            this.generalTabPage.SuspendLayout();
            this.recordTabPage.SuspendLayout();
            this.SuspendLayout();
            // 
            // settingTab
            // 
            this.settingTab.Controls.Add(this.generalTabPage);
            this.settingTab.Controls.Add(this.recordTabPage);
            this.settingTab.Controls.Add(this.recordTimingTabPage);
            this.settingTab.Controls.Add(this.sendTimingTabPage);
            this.settingTab.Dock = System.Windows.Forms.DockStyle.Fill;
            this.settingTab.Location = new System.Drawing.Point(0, 0);
            this.settingTab.Name = "settingTab";
            this.settingTab.SelectedIndex = 0;
            this.settingTab.Size = new System.Drawing.Size(240, 268);
            this.settingTab.TabIndex = 0;
            // 
            // recordTimingTabPage
            // 
            this.recordTimingTabPage.Controls.Add(this.recordOnChargeChangeCheckBox);
            this.recordTimingTabPage.Controls.Add(this.recordOnLevelChangeCheckBox);
            this.recordTimingTabPage.Controls.Add(this.panel3);
            this.recordTimingTabPage.Controls.Add(this.panel4);
            this.recordTimingTabPage.Location = new System.Drawing.Point(0, 0);
            this.recordTimingTabPage.Name = "recordTimingTabPage";
            this.recordTimingTabPage.Size = new System.Drawing.Size(240, 245);
            this.recordTimingTabPage.Text = "記録タイミング";
            // 
            // sendTimingTabPage
            // 
            this.sendTimingTabPage.Controls.Add(this.sendOnChargeChangeCheckBox);
            this.sendTimingTabPage.Controls.Add(this.sendOnLevelChangeCheckBox);
            this.sendTimingTabPage.Controls.Add(this.panel2);
            this.sendTimingTabPage.Controls.Add(this.panel1);
            this.sendTimingTabPage.Controls.Add(this.panel5);
            this.sendTimingTabPage.Location = new System.Drawing.Point(0, 0);
            this.sendTimingTabPage.Name = "sendTimingTabPage";
            this.sendTimingTabPage.Size = new System.Drawing.Size(232, 242);
            this.sendTimingTabPage.Text = "送信タイミング";
            // 
            // label1
            // 
            this.label1.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.label1.Location = new System.Drawing.Point(4, 4);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(232, 33);
            this.label1.Text = "下記のタイミングで、自動的にバッテリ残量を記録します。";
            // 
            // recordOnIntervalCheckBox
            // 
            this.recordOnIntervalCheckBox.Dock = System.Windows.Forms.DockStyle.Top;
            this.recordOnIntervalCheckBox.Location = new System.Drawing.Point(0, 0);
            this.recordOnIntervalCheckBox.Name = "recordOnIntervalCheckBox";
            this.recordOnIntervalCheckBox.Size = new System.Drawing.Size(240, 20);
            this.recordOnIntervalCheckBox.TabIndex = 1;
            this.recordOnIntervalCheckBox.Text = "次の間隔で記録";
            // 
            // recordOnIntervalComboBox
            // 
            this.recordOnIntervalComboBox.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.recordOnIntervalComboBox.Items.Add("1");
            this.recordOnIntervalComboBox.Items.Add("3");
            this.recordOnIntervalComboBox.Items.Add("5");
            this.recordOnIntervalComboBox.Items.Add("10");
            this.recordOnIntervalComboBox.Items.Add("15");
            this.recordOnIntervalComboBox.Items.Add("30");
            this.recordOnIntervalComboBox.Items.Add("60");
            this.recordOnIntervalComboBox.Items.Add("90");
            this.recordOnIntervalComboBox.Items.Add("120");
            this.recordOnIntervalComboBox.Location = new System.Drawing.Point(161, 17);
            this.recordOnIntervalComboBox.Name = "recordOnIntervalComboBox";
            this.recordOnIntervalComboBox.Size = new System.Drawing.Size(50, 22);
            this.recordOnIntervalComboBox.TabIndex = 2;
            // 
            // label2
            // 
            this.label2.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.label2.Location = new System.Drawing.Point(217, 23);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(20, 16);
            this.label2.Text = "分";
            // 
            // recordOnChargeChangeCheckBox
            // 
            this.recordOnChargeChangeCheckBox.Dock = System.Windows.Forms.DockStyle.Top;
            this.recordOnChargeChangeCheckBox.Location = new System.Drawing.Point(0, 101);
            this.recordOnChargeChangeCheckBox.Name = "recordOnChargeChangeCheckBox";
            this.recordOnChargeChangeCheckBox.Size = new System.Drawing.Size(240, 20);
            this.recordOnChargeChangeCheckBox.TabIndex = 4;
            this.recordOnChargeChangeCheckBox.Text = "充電状態変化時に記録";
            // 
            // recordOnLevelChangeCheckBox
            // 
            this.recordOnLevelChangeCheckBox.Dock = System.Windows.Forms.DockStyle.Top;
            this.recordOnLevelChangeCheckBox.Location = new System.Drawing.Point(0, 81);
            this.recordOnLevelChangeCheckBox.Name = "recordOnLevelChangeCheckBox";
            this.recordOnLevelChangeCheckBox.Size = new System.Drawing.Size(240, 20);
            this.recordOnLevelChangeCheckBox.TabIndex = 5;
            this.recordOnLevelChangeCheckBox.Text = "バッテリレベル変化時に記録";
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.label4);
            this.panel1.Controls.Add(this.sendOnIntervalComboBox);
            this.panel1.Controls.Add(this.sendOnIntervalCheckBox);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Top;
            this.panel1.Location = new System.Drawing.Point(0, 41);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(232, 40);
            // 
            // label3
            // 
            this.label3.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.label3.Location = new System.Drawing.Point(4, 4);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(224, 33);
            this.label3.Text = "下記のタイミングで、自動的にバッテリ残量をサーバに送信します。";
            // 
            // sendOnIntervalCheckBox
            // 
            this.sendOnIntervalCheckBox.Dock = System.Windows.Forms.DockStyle.Top;
            this.sendOnIntervalCheckBox.Location = new System.Drawing.Point(0, 0);
            this.sendOnIntervalCheckBox.Name = "sendOnIntervalCheckBox";
            this.sendOnIntervalCheckBox.Size = new System.Drawing.Size(232, 20);
            this.sendOnIntervalCheckBox.TabIndex = 0;
            this.sendOnIntervalCheckBox.Text = "次の間隔で送信";
            // 
            // sendOnIntervalComboBox
            // 
            this.sendOnIntervalComboBox.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.sendOnIntervalComboBox.Location = new System.Drawing.Point(153, 17);
            this.sendOnIntervalComboBox.Name = "sendOnIntervalComboBox";
            this.sendOnIntervalComboBox.Size = new System.Drawing.Size(50, 22);
            this.sendOnIntervalComboBox.TabIndex = 1;
            // 
            // label4
            // 
            this.label4.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.label4.Location = new System.Drawing.Point(209, 23);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(20, 16);
            this.label4.Text = "分";
            // 
            // panel2
            // 
            this.panel2.Controls.Add(this.label5);
            this.panel2.Controls.Add(this.sendOnCountComboBox);
            this.panel2.Controls.Add(this.sendOnCountCheckBox);
            this.panel2.Dock = System.Windows.Forms.DockStyle.Top;
            this.panel2.Location = new System.Drawing.Point(0, 81);
            this.panel2.Name = "panel2";
            this.panel2.Size = new System.Drawing.Size(232, 40);
            // 
            // sendOnCountCheckBox
            // 
            this.sendOnCountCheckBox.Dock = System.Windows.Forms.DockStyle.Top;
            this.sendOnCountCheckBox.Location = new System.Drawing.Point(0, 0);
            this.sendOnCountCheckBox.Name = "sendOnCountCheckBox";
            this.sendOnCountCheckBox.Size = new System.Drawing.Size(232, 20);
            this.sendOnCountCheckBox.TabIndex = 0;
            this.sendOnCountCheckBox.Text = "次の数溜まったら送信";
            // 
            // sendOnCountComboBox
            // 
            this.sendOnCountComboBox.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.sendOnCountComboBox.Items.Add("1");
            this.sendOnCountComboBox.Items.Add("3");
            this.sendOnCountComboBox.Items.Add("5");
            this.sendOnCountComboBox.Items.Add("10");
            this.sendOnCountComboBox.Items.Add("15");
            this.sendOnCountComboBox.Items.Add("20");
            this.sendOnCountComboBox.Items.Add("30");
            this.sendOnCountComboBox.Location = new System.Drawing.Point(153, 17);
            this.sendOnCountComboBox.Name = "sendOnCountComboBox";
            this.sendOnCountComboBox.Size = new System.Drawing.Size(50, 22);
            this.sendOnCountComboBox.TabIndex = 1;
            // 
            // label5
            // 
            this.label5.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.label5.Location = new System.Drawing.Point(209, 23);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(20, 16);
            this.label5.Text = "件";
            // 
            // sendOnLevelChangeCheckBox
            // 
            this.sendOnLevelChangeCheckBox.Dock = System.Windows.Forms.DockStyle.Top;
            this.sendOnLevelChangeCheckBox.Location = new System.Drawing.Point(0, 121);
            this.sendOnLevelChangeCheckBox.Name = "sendOnLevelChangeCheckBox";
            this.sendOnLevelChangeCheckBox.Size = new System.Drawing.Size(232, 20);
            this.sendOnLevelChangeCheckBox.TabIndex = 3;
            this.sendOnLevelChangeCheckBox.Text = "バッテリレベル変化時に送信";
            // 
            // sendOnChargeChangeCheckBox
            // 
            this.sendOnChargeChangeCheckBox.Dock = System.Windows.Forms.DockStyle.Top;
            this.sendOnChargeChangeCheckBox.Location = new System.Drawing.Point(0, 141);
            this.sendOnChargeChangeCheckBox.Name = "sendOnChargeChangeCheckBox";
            this.sendOnChargeChangeCheckBox.Size = new System.Drawing.Size(232, 20);
            this.sendOnChargeChangeCheckBox.TabIndex = 4;
            this.sendOnChargeChangeCheckBox.Text = "充電状態変化時に送信";
            // 
            // panel3
            // 
            this.panel3.Controls.Add(this.label2);
            this.panel3.Controls.Add(this.recordOnIntervalComboBox);
            this.panel3.Controls.Add(this.recordOnIntervalCheckBox);
            this.panel3.Dock = System.Windows.Forms.DockStyle.Top;
            this.panel3.Location = new System.Drawing.Point(0, 41);
            this.panel3.Name = "panel3";
            this.panel3.Size = new System.Drawing.Size(240, 40);
            // 
            // panel4
            // 
            this.panel4.Controls.Add(this.label1);
            this.panel4.Dock = System.Windows.Forms.DockStyle.Top;
            this.panel4.Location = new System.Drawing.Point(0, 0);
            this.panel4.Name = "panel4";
            this.panel4.Size = new System.Drawing.Size(240, 41);
            // 
            // panel5
            // 
            this.panel5.Controls.Add(this.label3);
            this.panel5.Dock = System.Windows.Forms.DockStyle.Top;
            this.panel5.Location = new System.Drawing.Point(0, 0);
            this.panel5.Name = "panel5";
            this.panel5.Size = new System.Drawing.Size(232, 41);
            // 
            // generalTabPage
            // 
            this.generalTabPage.Controls.Add(this.validTokenLabel);
            this.generalTabPage.Controls.Add(this.invalidTokenLabel);
            this.generalTabPage.Controls.Add(this.tokenTextBox);
            this.generalTabPage.Controls.Add(this.label6);
            this.generalTabPage.Location = new System.Drawing.Point(0, 0);
            this.generalTabPage.Name = "generalTabPage";
            this.generalTabPage.Size = new System.Drawing.Size(240, 245);
            this.generalTabPage.Text = "基本";
            // 
            // label6
            // 
            this.label6.Location = new System.Drawing.Point(7, 4);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(158, 20);
            this.label6.Text = "デバイストークン";
            // 
            // tokenTextBox
            // 
            this.tokenTextBox.Location = new System.Drawing.Point(7, 27);
            this.tokenTextBox.Name = "tokenTextBox";
            this.tokenTextBox.Size = new System.Drawing.Size(226, 21);
            this.tokenTextBox.TabIndex = 1;
            this.tokenTextBox.TextChanged += new System.EventHandler(this.tokenTextBox_TextChanged);
            // 
            // recordTabPage
            // 
            this.recordTabPage.Controls.Add(this.noRecordOnAcConnectCheckBox);
            this.recordTabPage.Controls.Add(this.noRecordOnChargeCheckBox);
            this.recordTabPage.Location = new System.Drawing.Point(0, 0);
            this.recordTabPage.Name = "recordTabPage";
            this.recordTabPage.Size = new System.Drawing.Size(240, 245);
            this.recordTabPage.Text = "記録";
            // 
            // noRecordOnChargeCheckBox
            // 
            this.noRecordOnChargeCheckBox.Location = new System.Drawing.Point(7, 7);
            this.noRecordOnChargeCheckBox.Name = "noRecordOnChargeCheckBox";
            this.noRecordOnChargeCheckBox.Size = new System.Drawing.Size(226, 20);
            this.noRecordOnChargeCheckBox.TabIndex = 0;
            this.noRecordOnChargeCheckBox.Text = "充電中は記録しない";
            // 
            // noRecordOnAcConnectCheckBox
            // 
            this.noRecordOnAcConnectCheckBox.Location = new System.Drawing.Point(7, 33);
            this.noRecordOnAcConnectCheckBox.Name = "noRecordOnAcConnectCheckBox";
            this.noRecordOnAcConnectCheckBox.Size = new System.Drawing.Size(226, 20);
            this.noRecordOnAcConnectCheckBox.TabIndex = 1;
            this.noRecordOnAcConnectCheckBox.Text = "電源接続中は記録しない";
            // 
            // invalidTokenLabel
            // 
            this.invalidTokenLabel.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(192)))), ((int)(((byte)(0)))), ((int)(((byte)(0)))));
            this.invalidTokenLabel.Location = new System.Drawing.Point(7, 51);
            this.invalidTokenLabel.Name = "invalidTokenLabel";
            this.invalidTokenLabel.Size = new System.Drawing.Size(226, 33);
            this.invalidTokenLabel.Text = "デバイストークンが正しい形式ではありません。";
            // 
            // validTokenLabel
            // 
            this.validTokenLabel.ForeColor = System.Drawing.Color.Green;
            this.validTokenLabel.Location = new System.Drawing.Point(7, 84);
            this.validTokenLabel.Name = "validTokenLabel";
            this.validTokenLabel.Size = new System.Drawing.Size(226, 33);
            this.validTokenLabel.Text = "デバイストークンは正しい形式です。";
            // 
            // SettingForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(96F, 96F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Dpi;
            this.AutoScroll = true;
            this.ClientSize = new System.Drawing.Size(240, 268);
            this.Controls.Add(this.settingTab);
            this.Menu = this.mainMenu1;
            this.Name = "SettingForm";
            this.Text = "設定";
            this.settingTab.ResumeLayout(false);
            this.recordTimingTabPage.ResumeLayout(false);
            this.sendTimingTabPage.ResumeLayout(false);
            this.panel1.ResumeLayout(false);
            this.panel2.ResumeLayout(false);
            this.panel3.ResumeLayout(false);
            this.panel4.ResumeLayout(false);
            this.panel5.ResumeLayout(false);
            this.generalTabPage.ResumeLayout(false);
            this.recordTabPage.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.TabControl settingTab;
        private System.Windows.Forms.TabPage recordTimingTabPage;
        private System.Windows.Forms.TabPage sendTimingTabPage;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.ComboBox recordOnIntervalComboBox;
        private System.Windows.Forms.CheckBox recordOnIntervalCheckBox;
        private System.Windows.Forms.CheckBox recordOnLevelChangeCheckBox;
        private System.Windows.Forms.CheckBox recordOnChargeChangeCheckBox;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.ComboBox sendOnIntervalComboBox;
        private System.Windows.Forms.CheckBox sendOnIntervalCheckBox;
        private System.Windows.Forms.Panel panel2;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.ComboBox sendOnCountComboBox;
        private System.Windows.Forms.CheckBox sendOnCountCheckBox;
        private System.Windows.Forms.CheckBox sendOnChargeChangeCheckBox;
        private System.Windows.Forms.CheckBox sendOnLevelChangeCheckBox;
        private System.Windows.Forms.Panel panel3;
        private System.Windows.Forms.Panel panel4;
        private System.Windows.Forms.Panel panel5;
        private System.Windows.Forms.TabPage generalTabPage;
        private System.Windows.Forms.TextBox tokenTextBox;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.TabPage recordTabPage;
        private System.Windows.Forms.CheckBox noRecordOnAcConnectCheckBox;
        private System.Windows.Forms.CheckBox noRecordOnChargeCheckBox;
        private System.Windows.Forms.Label validTokenLabel;
        private System.Windows.Forms.Label invalidTokenLabel;
    }
}