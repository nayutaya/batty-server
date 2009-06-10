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
            this.currentChargingLabel = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.currentLineLabel = new System.Windows.Forms.Label();
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
            this.currentLevelLabel.Location = new System.Drawing.Point(111, 71);
            this.currentLevelLabel.Name = "currentLevelLabel";
            this.currentLevelLabel.Size = new System.Drawing.Size(95, 20);
            this.currentLevelLabel.Text = "-";
            // 
            // currentChargingLabel
            // 
            this.currentChargingLabel.Location = new System.Drawing.Point(111, 91);
            this.currentChargingLabel.Name = "currentChargingLabel";
            this.currentChargingLabel.Size = new System.Drawing.Size(95, 20);
            this.currentChargingLabel.Text = "-";
            // 
            // label1
            // 
            this.label1.Location = new System.Drawing.Point(20, 71);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(85, 20);
            this.label1.Text = "バッテリ残量 :";
            this.label1.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // label2
            // 
            this.label2.Location = new System.Drawing.Point(20, 91);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(85, 20);
            this.label2.Text = "充電中 :";
            this.label2.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // label3
            // 
            this.label3.Location = new System.Drawing.Point(20, 111);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(85, 20);
            this.label3.Text = "電源接続中 :";
            this.label3.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // currentLineLabel
            // 
            this.currentLineLabel.Location = new System.Drawing.Point(111, 111);
            this.currentLineLabel.Name = "currentLineLabel";
            this.currentLineLabel.Size = new System.Drawing.Size(95, 20);
            this.currentLineLabel.Text = "-";
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(96F, 96F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Dpi;
            this.AutoScroll = true;
            this.ClientSize = new System.Drawing.Size(240, 268);
            this.Controls.Add(this.currentLineLabel);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.currentChargingLabel);
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
        private System.Windows.Forms.Label currentChargingLabel;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label currentLineLabel;
    }
}

