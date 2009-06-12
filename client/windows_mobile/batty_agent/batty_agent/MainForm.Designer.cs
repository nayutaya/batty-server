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
            this.currentLevelLabel = new System.Windows.Forms.Label();
            this.currentChargingLabel = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.currentLineLabel = new System.Windows.Forms.Label();
            this.sendButton = new System.Windows.Forms.Button();
            this.panel1 = new System.Windows.Forms.Panel();
            this.tokenTextBox = new System.Windows.Forms.TextBox();
            this.listView1 = new System.Windows.Forms.ListView();
            this.columnHeader1 = new System.Windows.Forms.ColumnHeader();
            this.columnHeader2 = new System.Windows.Forms.ColumnHeader();
            this.panel1.SuspendLayout();
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
            this.showCurrentLevelButton.Location = new System.Drawing.Point(3, 29);
            this.showCurrentLevelButton.Name = "showCurrentLevelButton";
            this.showCurrentLevelButton.Size = new System.Drawing.Size(72, 20);
            this.showCurrentLevelButton.TabIndex = 1;
            this.showCurrentLevelButton.Text = "現在値";
            this.showCurrentLevelButton.Click += new System.EventHandler(this.showCurrentLevelButton_Click);
            // 
            // currentLevelLabel
            // 
            this.currentLevelLabel.Location = new System.Drawing.Point(94, 3);
            this.currentLevelLabel.Name = "currentLevelLabel";
            this.currentLevelLabel.Size = new System.Drawing.Size(49, 20);
            this.currentLevelLabel.Text = "-";
            // 
            // currentChargingLabel
            // 
            this.currentChargingLabel.Location = new System.Drawing.Point(94, 23);
            this.currentChargingLabel.Name = "currentChargingLabel";
            this.currentChargingLabel.Size = new System.Drawing.Size(49, 20);
            this.currentChargingLabel.Text = "-";
            // 
            // label1
            // 
            this.label1.Location = new System.Drawing.Point(3, 3);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(85, 20);
            this.label1.Text = "バッテリ残量 :";
            this.label1.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // label2
            // 
            this.label2.Location = new System.Drawing.Point(3, 23);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(85, 20);
            this.label2.Text = "充電中 :";
            this.label2.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // label3
            // 
            this.label3.Location = new System.Drawing.Point(3, 43);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(85, 20);
            this.label3.Text = "電源接続中 :";
            this.label3.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // currentLineLabel
            // 
            this.currentLineLabel.Location = new System.Drawing.Point(94, 43);
            this.currentLineLabel.Name = "currentLineLabel";
            this.currentLineLabel.Size = new System.Drawing.Size(49, 20);
            this.currentLineLabel.Text = "-";
            // 
            // sendButton
            // 
            this.sendButton.Location = new System.Drawing.Point(3, 103);
            this.sendButton.Name = "sendButton";
            this.sendButton.Size = new System.Drawing.Size(72, 20);
            this.sendButton.TabIndex = 8;
            this.sendButton.Text = "送信";
            this.sendButton.Click += new System.EventHandler(this.sendButton_Click);
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.label3);
            this.panel1.Controls.Add(this.label1);
            this.panel1.Controls.Add(this.currentLevelLabel);
            this.panel1.Controls.Add(this.currentChargingLabel);
            this.panel1.Controls.Add(this.currentLineLabel);
            this.panel1.Controls.Add(this.label2);
            this.panel1.Location = new System.Drawing.Point(81, 29);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(151, 68);
            // 
            // tokenTextBox
            // 
            this.tokenTextBox.Location = new System.Drawing.Point(81, 103);
            this.tokenTextBox.MaxLength = 20;
            this.tokenTextBox.Name = "tokenTextBox";
            this.tokenTextBox.Size = new System.Drawing.Size(111, 21);
            this.tokenTextBox.TabIndex = 11;
            this.tokenTextBox.WordWrap = false;
            // 
            // listView1
            // 
            this.listView1.Columns.Add(this.columnHeader1);
            this.listView1.Columns.Add(this.columnHeader2);
            this.listView1.HeaderStyle = System.Windows.Forms.ColumnHeaderStyle.Nonclickable;
            this.listView1.Location = new System.Drawing.Point(3, 130);
            this.listView1.Name = "listView1";
            this.listView1.Size = new System.Drawing.Size(234, 135);
            this.listView1.TabIndex = 15;
            this.listView1.View = System.Windows.Forms.View.Details;
            // 
            // columnHeader1
            // 
            this.columnHeader1.Text = "time";
            this.columnHeader1.Width = 70;
            // 
            // columnHeader2
            // 
            this.columnHeader2.Text = "message";
            this.columnHeader2.Width = 130;
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(96F, 96F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Dpi;
            this.AutoScroll = true;
            this.ClientSize = new System.Drawing.Size(240, 268);
            this.Controls.Add(this.listView1);
            this.Controls.Add(this.tokenTextBox);
            this.Controls.Add(this.panel1);
            this.Controls.Add(this.sendButton);
            this.Controls.Add(this.showCurrentLevelButton);
            this.Controls.Add(this.exitButton);
            this.Menu = this.mainMenu1;
            this.Name = "MainForm";
            this.Text = "Batty Agent";
            this.panel1.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button exitButton;
        private System.Windows.Forms.Button showCurrentLevelButton;
        private System.Windows.Forms.Label currentLevelLabel;
        private System.Windows.Forms.Label currentChargingLabel;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label currentLineLabel;
        private System.Windows.Forms.Button sendButton;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.TextBox tokenTextBox;
        private System.Windows.Forms.ListView listView1;
        private System.Windows.Forms.ColumnHeader columnHeader1;
        private System.Windows.Forms.ColumnHeader columnHeader2;
    }
}

