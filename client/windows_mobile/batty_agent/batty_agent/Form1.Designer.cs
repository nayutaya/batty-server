namespace batty_agent
{
    partial class Form1
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
            this.currentStatusLabel = new System.Windows.Forms.Label();
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
            this.currentLevelLabel.Location = new System.Drawing.Point(81, 29);
            this.currentLevelLabel.Name = "currentLevelLabel";
            this.currentLevelLabel.Size = new System.Drawing.Size(44, 20);
            this.currentLevelLabel.Text = "-";
            this.currentLevelLabel.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // currentStatusLabel
            // 
            this.currentStatusLabel.Location = new System.Drawing.Point(131, 29);
            this.currentStatusLabel.Name = "currentStatusLabel";
            this.currentStatusLabel.Size = new System.Drawing.Size(106, 20);
            this.currentStatusLabel.Text = "-";
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(96F, 96F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Dpi;
            this.AutoScroll = true;
            this.ClientSize = new System.Drawing.Size(240, 268);
            this.Controls.Add(this.currentStatusLabel);
            this.Controls.Add(this.currentLevelLabel);
            this.Controls.Add(this.showCurrentLevelButton);
            this.Controls.Add(this.exitButton);
            this.Menu = this.mainMenu1;
            this.Name = "Form1";
            this.Text = "Batty Agent";
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button exitButton;
        private System.Windows.Forms.Button showCurrentLevelButton;
        private System.Windows.Forms.Label currentLevelLabel;
        private System.Windows.Forms.Label currentStatusLabel;
    }
}

