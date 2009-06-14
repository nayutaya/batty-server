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
            this.recordTabPage = new System.Windows.Forms.TabPage();
            this.sendTabPage = new System.Windows.Forms.TabPage();
            this.label1 = new System.Windows.Forms.Label();
            this.recordOnIntervalCheckBox = new System.Windows.Forms.CheckBox();
            this.recordOnIntervalComboBox = new System.Windows.Forms.ComboBox();
            this.label2 = new System.Windows.Forms.Label();
            this.recordOnChargeChangeCheckBox = new System.Windows.Forms.CheckBox();
            this.recordOnLevelChangeCheckBox = new System.Windows.Forms.CheckBox();
            this.panel1 = new System.Windows.Forms.Panel();
            this.label3 = new System.Windows.Forms.Label();
            this.checkBox1 = new System.Windows.Forms.CheckBox();
            this.comboBox2 = new System.Windows.Forms.ComboBox();
            this.label4 = new System.Windows.Forms.Label();
            this.panel2 = new System.Windows.Forms.Panel();
            this.checkBox2 = new System.Windows.Forms.CheckBox();
            this.comboBox3 = new System.Windows.Forms.ComboBox();
            this.label5 = new System.Windows.Forms.Label();
            this.checkBox3 = new System.Windows.Forms.CheckBox();
            this.checkBox4 = new System.Windows.Forms.CheckBox();
            this.panel3 = new System.Windows.Forms.Panel();
            this.panel4 = new System.Windows.Forms.Panel();
            this.panel5 = new System.Windows.Forms.Panel();
            this.settingTab.SuspendLayout();
            this.recordTabPage.SuspendLayout();
            this.sendTabPage.SuspendLayout();
            this.panel1.SuspendLayout();
            this.panel2.SuspendLayout();
            this.panel3.SuspendLayout();
            this.panel4.SuspendLayout();
            this.panel5.SuspendLayout();
            this.SuspendLayout();
            // 
            // settingTab
            // 
            this.settingTab.Controls.Add(this.recordTabPage);
            this.settingTab.Controls.Add(this.sendTabPage);
            this.settingTab.Dock = System.Windows.Forms.DockStyle.Fill;
            this.settingTab.Location = new System.Drawing.Point(0, 0);
            this.settingTab.Name = "settingTab";
            this.settingTab.SelectedIndex = 0;
            this.settingTab.Size = new System.Drawing.Size(240, 268);
            this.settingTab.TabIndex = 0;
            // 
            // recordTabPage
            // 
            this.recordTabPage.Controls.Add(this.recordOnChargeChangeCheckBox);
            this.recordTabPage.Controls.Add(this.recordOnLevelChangeCheckBox);
            this.recordTabPage.Controls.Add(this.panel3);
            this.recordTabPage.Controls.Add(this.panel4);
            this.recordTabPage.Location = new System.Drawing.Point(0, 0);
            this.recordTabPage.Name = "recordTabPage";
            this.recordTabPage.Size = new System.Drawing.Size(240, 245);
            this.recordTabPage.Text = "記録";
            // 
            // sendTabPage
            // 
            this.sendTabPage.Controls.Add(this.checkBox3);
            this.sendTabPage.Controls.Add(this.checkBox4);
            this.sendTabPage.Controls.Add(this.panel2);
            this.sendTabPage.Controls.Add(this.panel1);
            this.sendTabPage.Controls.Add(this.panel5);
            this.sendTabPage.Location = new System.Drawing.Point(0, 0);
            this.sendTabPage.Name = "sendTabPage";
            this.sendTabPage.Size = new System.Drawing.Size(240, 245);
            this.sendTabPage.Text = "送信";
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
            this.panel1.Controls.Add(this.comboBox2);
            this.panel1.Controls.Add(this.checkBox1);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Top;
            this.panel1.Location = new System.Drawing.Point(0, 41);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(240, 40);
            // 
            // label3
            // 
            this.label3.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.label3.Location = new System.Drawing.Point(4, 4);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(232, 33);
            this.label3.Text = "下記のタイミングで、自動的にバッテリ残量をサーバに送信します。";
            // 
            // checkBox1
            // 
            this.checkBox1.Dock = System.Windows.Forms.DockStyle.Top;
            this.checkBox1.Location = new System.Drawing.Point(0, 0);
            this.checkBox1.Name = "checkBox1";
            this.checkBox1.Size = new System.Drawing.Size(240, 20);
            this.checkBox1.TabIndex = 0;
            this.checkBox1.Text = "次の間隔で送信";
            // 
            // comboBox2
            // 
            this.comboBox2.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.comboBox2.Location = new System.Drawing.Point(161, 17);
            this.comboBox2.Name = "comboBox2";
            this.comboBox2.Size = new System.Drawing.Size(50, 22);
            this.comboBox2.TabIndex = 1;
            // 
            // label4
            // 
            this.label4.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.label4.Location = new System.Drawing.Point(217, 23);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(20, 16);
            this.label4.Text = "分";
            // 
            // panel2
            // 
            this.panel2.Controls.Add(this.label5);
            this.panel2.Controls.Add(this.comboBox3);
            this.panel2.Controls.Add(this.checkBox2);
            this.panel2.Dock = System.Windows.Forms.DockStyle.Top;
            this.panel2.Location = new System.Drawing.Point(0, 81);
            this.panel2.Name = "panel2";
            this.panel2.Size = new System.Drawing.Size(240, 40);
            // 
            // checkBox2
            // 
            this.checkBox2.Dock = System.Windows.Forms.DockStyle.Top;
            this.checkBox2.Location = new System.Drawing.Point(0, 0);
            this.checkBox2.Name = "checkBox2";
            this.checkBox2.Size = new System.Drawing.Size(240, 20);
            this.checkBox2.TabIndex = 0;
            this.checkBox2.Text = "次の数溜まったら送信";
            // 
            // comboBox3
            // 
            this.comboBox3.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.comboBox3.Items.Add("1");
            this.comboBox3.Items.Add("3");
            this.comboBox3.Items.Add("5");
            this.comboBox3.Items.Add("10");
            this.comboBox3.Items.Add("15");
            this.comboBox3.Items.Add("20");
            this.comboBox3.Items.Add("30");
            this.comboBox3.Location = new System.Drawing.Point(161, 17);
            this.comboBox3.Name = "comboBox3";
            this.comboBox3.Size = new System.Drawing.Size(50, 22);
            this.comboBox3.TabIndex = 1;
            // 
            // label5
            // 
            this.label5.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.label5.Location = new System.Drawing.Point(217, 23);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(20, 16);
            this.label5.Text = "件";
            // 
            // checkBox3
            // 
            this.checkBox3.Dock = System.Windows.Forms.DockStyle.Top;
            this.checkBox3.Location = new System.Drawing.Point(0, 141);
            this.checkBox3.Name = "checkBox3";
            this.checkBox3.Size = new System.Drawing.Size(240, 20);
            this.checkBox3.TabIndex = 3;
            this.checkBox3.Text = "バッテリレベル変化時に送信";
            // 
            // checkBox4
            // 
            this.checkBox4.Dock = System.Windows.Forms.DockStyle.Top;
            this.checkBox4.Location = new System.Drawing.Point(0, 121);
            this.checkBox4.Name = "checkBox4";
            this.checkBox4.Size = new System.Drawing.Size(240, 20);
            this.checkBox4.TabIndex = 4;
            this.checkBox4.Text = "充電状態変化時に送信";
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
            this.panel5.Size = new System.Drawing.Size(240, 41);
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
            this.recordTabPage.ResumeLayout(false);
            this.sendTabPage.ResumeLayout(false);
            this.panel1.ResumeLayout(false);
            this.panel2.ResumeLayout(false);
            this.panel3.ResumeLayout(false);
            this.panel4.ResumeLayout(false);
            this.panel5.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.TabControl settingTab;
        private System.Windows.Forms.TabPage recordTabPage;
        private System.Windows.Forms.TabPage sendTabPage;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.ComboBox recordOnIntervalComboBox;
        private System.Windows.Forms.CheckBox recordOnIntervalCheckBox;
        private System.Windows.Forms.CheckBox recordOnLevelChangeCheckBox;
        private System.Windows.Forms.CheckBox recordOnChargeChangeCheckBox;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.ComboBox comboBox2;
        private System.Windows.Forms.CheckBox checkBox1;
        private System.Windows.Forms.Panel panel2;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.ComboBox comboBox3;
        private System.Windows.Forms.CheckBox checkBox2;
        private System.Windows.Forms.CheckBox checkBox4;
        private System.Windows.Forms.CheckBox checkBox3;
        private System.Windows.Forms.Panel panel3;
        private System.Windows.Forms.Panel panel4;
        private System.Windows.Forms.Panel panel5;
    }
}