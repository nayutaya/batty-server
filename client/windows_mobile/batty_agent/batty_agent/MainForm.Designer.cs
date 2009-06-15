namespace nayutaya.batty.agent
{
    partial class MainForm
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
            if (disposing && (components != null))
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
            this.exitButton = new System.Windows.Forms.Button();
            this.showCurrentLevelButton = new System.Windows.Forms.Button();
            this.sendButton = new System.Windows.Forms.Button();
            this.tokenTextBox = new System.Windows.Forms.TextBox();
            this.listView1 = new System.Windows.Forms.ListView();
            this.columnHeader1 = new System.Windows.Forms.ColumnHeader();
            this.columnHeader2 = new System.Windows.Forms.ColumnHeader();
            this.settingButton = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // exitButton
            // 
            this.exitButton.Location = new System.Drawing.Point(3, 3);
            this.exitButton.Name = "exitButton";
            this.exitButton.Size = new System.Drawing.Size(72, 20);
            this.exitButton.TabIndex = 0;
            this.exitButton.Text = "終了";
            this.exitButton.Click += new System.EventHandler(this.exitButton_Click);
            // 
            // showCurrentLevelButton
            // 
            this.showCurrentLevelButton.Location = new System.Drawing.Point(81, 3);
            this.showCurrentLevelButton.Name = "showCurrentLevelButton";
            this.showCurrentLevelButton.Size = new System.Drawing.Size(72, 20);
            this.showCurrentLevelButton.TabIndex = 1;
            this.showCurrentLevelButton.Text = "現在値";
            this.showCurrentLevelButton.Click += new System.EventHandler(this.showCurrentLevelButton_Click);
            // 
            // sendButton
            // 
            this.sendButton.Location = new System.Drawing.Point(3, 29);
            this.sendButton.Name = "sendButton";
            this.sendButton.Size = new System.Drawing.Size(72, 20);
            this.sendButton.TabIndex = 8;
            this.sendButton.Text = "送信";
            this.sendButton.Click += new System.EventHandler(this.sendButton_Click);
            // 
            // tokenTextBox
            // 
            this.tokenTextBox.Location = new System.Drawing.Point(81, 29);
            this.tokenTextBox.MaxLength = 20;
            this.tokenTextBox.Name = "tokenTextBox";
            this.tokenTextBox.Size = new System.Drawing.Size(150, 21);
            this.tokenTextBox.TabIndex = 11;
            this.tokenTextBox.WordWrap = false;
            // 
            // listView1
            // 
            this.listView1.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.listView1.Columns.Add(this.columnHeader1);
            this.listView1.Columns.Add(this.columnHeader2);
            this.listView1.HeaderStyle = System.Windows.Forms.ColumnHeaderStyle.Nonclickable;
            this.listView1.Location = new System.Drawing.Point(3, 56);
            this.listView1.Name = "listView1";
            this.listView1.Size = new System.Drawing.Size(234, 209);
            this.listView1.TabIndex = 15;
            this.listView1.View = System.Windows.Forms.View.Details;
            // 
            // columnHeader1
            // 
            this.columnHeader1.Text = "time";
            this.columnHeader1.Width = 65;
            // 
            // columnHeader2
            // 
            this.columnHeader2.Text = "message";
            this.columnHeader2.Width = 145;
            // 
            // settingButton
            // 
            this.settingButton.Location = new System.Drawing.Point(159, 3);
            this.settingButton.Name = "settingButton";
            this.settingButton.Size = new System.Drawing.Size(72, 20);
            this.settingButton.TabIndex = 17;
            this.settingButton.Text = "設定";
            this.settingButton.Click += new System.EventHandler(this.settingButton_Click);
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(96F, 96F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Dpi;
            this.AutoScroll = true;
            this.ClientSize = new System.Drawing.Size(240, 268);
            this.Controls.Add(this.settingButton);
            this.Controls.Add(this.listView1);
            this.Controls.Add(this.tokenTextBox);
            this.Controls.Add(this.sendButton);
            this.Controls.Add(this.showCurrentLevelButton);
            this.Controls.Add(this.exitButton);
            this.Menu = this.mainMenu1;
            this.Name = "MainForm";
            this.Text = "Batty Agent";
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button exitButton;
        private System.Windows.Forms.Button showCurrentLevelButton;
        private System.Windows.Forms.Button sendButton;
        private System.Windows.Forms.TextBox tokenTextBox;
        private System.Windows.Forms.ListView listView1;
        private System.Windows.Forms.ColumnHeader columnHeader1;
        private System.Windows.Forms.ColumnHeader columnHeader2;
        private System.Windows.Forms.Button settingButton;
    }
}

