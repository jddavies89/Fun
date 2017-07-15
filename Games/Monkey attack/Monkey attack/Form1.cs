/*
============================================================================================
  AUTHOR        :   Joe Richards
  CREATE DATE   :   15/07/2017
  PURPOSE       :   Catch as many benanas a posible without the enemy catching the monkey.
  VERSION       :   1.0
============================================================================================

This file is part of Monkey Attack.

Monkey attack is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Monkey Attack is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

Please visit the GNU General Public License for more details: http://www.gnu.org/licenses/.

============================================================================================
*/
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Monkey_attack
{
    public partial class frmMain : Form
    {
        PictureBox player;
        PictureBox benanas;
        PictureBox enemy;
        Label lblScore;
        Timer tmr1;
        Timer tmrWinner;
        Random rnd;

        //Player goes left if true.
        bool goLeft;
        //player goes right if true.
        bool goRight;
        //Movement speed of the benana and enemy is 6.
        int speed = 6;
        //Movement speed of the monkey is 6;
        int monkeySpeed = 6;
        //Stores if the player is jumping or not.
        bool jump;
        //Gravity
        int gravity = 35;
        //Stores the boundary of the ground.
        int ground;
        //Stores the falling speed.
        int force;
        //Stores if an  benana exists or not.
        bool benanaExists;
        //Stores if an enemy exists or not.
        bool enemyExists;
        //Keeps a score.
        int score = 1;
        //Stores the working directory.
        string dir = System.IO.Directory.GetCurrentDirectory();
        //Files used within the working directory.;
        string oneBenana = @"\1Benana.png";
        string twoBenana = @"\2Benana.png";
        string oneEnemy = @"\enemy.png";
        string monkey = @"\monkey.png";
        string icon = @"\2benanaIcon.ico";
        //Stores the random number to display a benana.
        int displayBenana;
        
        public frmMain()
        {
            InitializeComponent();           
            setup();
        }   

        public void setup()
        {
            //Adjusts the main form.
            this.Size = new Size(600, 600);
            this.BackColor = Color.Gray;
            this.Text = "Monkey Attack";
            this.Icon = new Icon(dir + icon);

            //Creates the player.
            player = new PictureBox();
            //Stores the height of the ground.
            ground = this.Height - player.Height - player.Height;
            //
            player.SizeMode = PictureBoxSizeMode.StretchImage;
            player.BackColor = Color.Transparent;
            player.Image = Image.FromFile(dir +  monkey);
            player.Size = new Size(30, 50);
            player.Tag = "player";
            player.Location = new Point(10, ground);           
            this.Controls.Add(player);

            //Creates the score board.
            lblScore = new Label();
            lblScore.AutoSize = true;
            lblScore.Tag = "lblScore";
            lblScore.BackColor = Color.Transparent;
            lblScore.BackColor = Color.Silver;
            lblScore.Location = new Point(10, ground);
            this.Controls.Add(lblScore);
            
            //Creates the timer.
            tmr1 = new Timer();
            tmr1.Tick += new EventHandler(tmr_Tick);
            tmr1.Interval = 25;
            tmr1.Start();

            //Creates the timer.
            tmrWinner = new Timer();
            tmrWinner.Tick += new EventHandler(tmrWinner_Tick);
            tmrWinner.Interval = 25;
            tmrWinner.Stop();  
        }

        private void tmr_Tick(object sender, EventArgs e)
        {
            //Move player left.
            if (goLeft)
            {
                player.Left -= monkeySpeed;
            }
            //Move player right.
            if (goRight)
            {
                player.Left += monkeySpeed;
            }

            //Player fall at the peak of jump.
            if (jump == true)
            {
                player.Top -= force;
                force -= 1;
            }

            //Stop falling when player touches the ground.
            if (player.Top >= ground)
            {
                player.Top = ground;
                jump = false;
            }
            else
            {
                //player is falling.
                player.Top += 5;
            }

            //Stops player moving passed the bounds of the form.
            //Passed the left bound.
            if (player.Left < 0)
            {
                player.Left = 0;
            }
            //Passed the right bound.
            else if (player.Left > this.Width - player.Width)
            {
                player.Left = this.Width - player.Width;
            }
                       
            //create the benana and removes at the end.
            if (benanaExists)
            {
                //Moves the benana.
                foreach (Control p in this.Controls)
                {
                    if (p is PictureBox && p.Tag == "_benana")
                    {
                        //Moves the benana from right to left.
                        p.Left -= speed;
                        //Removes the benana when the benana reaches the left side of the form.
                        if (p.Right < 0)
                        {
                            //Removes the benana.
                            this.Controls.Remove(p);                            
                            //benana doesn't exist.
                            benanaExists = false;
                            //Create the benana.
                            CreateBenana();
                            //benana exists.
                            benanaExists = true;
                        }
                    }
                }
            }
            else
            {
                //Create the benana.
                CreateBenana();
                //benana exists.
                benanaExists = true;
            }

            //create the enemy and removes at the end.
            if (enemyExists)
            {
                //Moves the benana.
                foreach (Control x in this.Controls)
                {
                    if (x is PictureBox && x.Tag == "_enemy")
                    {
                        //Moves the benana from right to left.
                        x.Left -= speed;
                        //Removes the enemy when the enemy reaches the left side of the form.
                        if (x.Right < 0)
                        {
                            //Removes the enemy.
                            this.Controls.Remove(x);
                            //benana doesn't exist.
                            enemyExists = false;
                            //Create three enemies.
                            CreateEnemy();
                            //enemy exists.
                            enemyExists = true;
                        }
                    }
                }
            }
            else
            {
                //a enemy can only be displayed if there has been at least one benana caught.
                if (score > 1)
                {
                    //Create the enemy.
                    CreateEnemy();                   
                    //enemy exists.
                    enemyExists = true;
                }
                
            }

            //Check player boundary against benana boundry.
            foreach (Control j in this.Controls)
            {
                foreach (Control i in this.Controls)
                {
                    if (i is PictureBox && i.Tag == "_benana")
                    {
                        if (j is PictureBox && j.Tag == "player")
                        {
                            //Checks to see if the boundary of the benana touches the boundary of the player.
                            if (i.Bounds.IntersectsWith(j.Bounds))
                            {
                                //Removes the benana.
                                this.Controls.Remove(i);
                                //Shows the score on the label.
                                lblScore.Text = "Score: " + score;
                                //Updates the score.
                                score++;
                                //Creates a new benana.
                                CreateBenana();
                            }
                        }
                    }

                }
            }

            //Check player boundary against enemy boundry.
            foreach (Control j in this.Controls)
            {
                foreach (Control i in this.Controls)
                {
                    if (i is PictureBox && i.Tag == "_enemy")
                    {
                        if (j is PictureBox && j.Tag == "player")
                        {
                            //Checks to see if the boundary of the benana touches the boundary of the player.
                            if (i.Bounds.IntersectsWith(j.Bounds))
                            {
                                //Game is over.
                                gameOver();
                            }
                        }
                    }

                }
            }            
        }

        private void tmrWinner_Tick(object sender, EventArgs e)
        {
            //Displays the enemy on the screen.
            enemyWins();
        }

        private void frmMain_KeyDown(object sender, KeyEventArgs e)
        {            
            //Recognize the left arrow is pressed.
            if (e.KeyCode == Keys.Left)
            {
                goLeft = true;
            }
            //Recognize the right arrow is pressed.
            if(e.KeyCode == Keys.Right)
            {
                goRight = true;
            }
            //Recognize the space bar is pressed.
            if (jump != true){
                if (e.KeyCode == Keys.Space)
                {
                    jump = true;
                    force = gravity;
                }
            }
        }

        private void frmMain_KeyUp(object sender, KeyEventArgs e)
        {
            //Recognize the left arrow is not pressed.
            if (e.KeyCode == Keys.Left)
            {
                goLeft = false;
            }
            //Recognize the right arrow is not pressed.
            if (e.KeyCode == Keys.Right)
            {
                goRight = false;
            }
        }

        private void CreateBenana()
        {
            //Creates a benana that appears from the right side of the screen to the left, then disappears.
            //random number used for the benana x coordinates coming on the form and which Benana to use.
            rnd = new Random();
            //Randomizes which benana to use, which gets stored in the string benana.
            displayBenana = rnd.Next(1, 3);
            //random number used for the benana x coordinates coming on the form 
            rnd.Next(1, 3);
            //Create a benana.
            benanas = new PictureBox();
            benanas.SizeMode = PictureBoxSizeMode.StretchImage;
            benanas.BackColor = Color.Transparent;
            //Randomly chooses which benana to use.
            if (displayBenana == 1)
            {
                benanas.Image = Image.FromFile(dir + oneBenana);
            }
            else if (displayBenana == 2)
            {
                benanas.Image = Image.FromFile(dir + twoBenana);
            }
            else
            {
                benanas.Image = Image.FromFile(dir + oneBenana);
            }
            benanas.Size = new Size(25, 25);
            //Displays the benana on a random x coordinate on the right side of the form but higher than the monkey.
            benanas.Location = new Point(frmMain.ActiveForm.Width, rnd.Next(frmMain.ActiveForm.Height - benanas.Height - benanas.Height - benanas.Height - benanas.Height));
            benanas.Tag = "_benana";
            this.Controls.Add(benanas);
        }

        private void CreateEnemy()
        {
            //Creates a enemy that appears from the right side of the screen to the left, then disappears.
            enemy = new PictureBox();
            enemy.SizeMode = PictureBoxSizeMode.StretchImage;
            enemy.BackColor = Color.Transparent;
            enemy.Image = Image.FromFile(dir + oneEnemy);
            enemy.Size = new Size(25, 25);
            //Displays the enemy on a random x coordinate on the right side of the form but higher than the ground.
            enemy.Location = new Point(frmMain.ActiveForm.Width, rnd.Next(frmMain.ActiveForm.Height - enemy.Height - enemy.Height - enemy.Height - enemy.Height));
            enemy.Tag = "_enemy";
            this.Controls.Add(enemy);
        }

        private void enemyWins()
        {
            //Randomly displays the enemy all over the screen.           
            //Create an enemy..
            enemy = new PictureBox();
            enemy.SizeMode = PictureBoxSizeMode.StretchImage;
            enemy.BackColor = Color.Transparent;
            enemy.Image = Image.FromFile(dir + oneEnemy);
            enemy.Size = new Size(25, 25);
            //Displays the enemy randomly around the screen but higher than the ground.
            enemy.Location = new Point(rnd.Next(this.Width), rnd.Next(frmMain.ActiveForm.Height - enemy.Height - enemy.Height - enemy.Height - enemy.Height));
            enemy.Tag = "_enemy";
            this.Controls.Add(enemy);
        }

        private void gameOver()
        {
            //Stops the timer.
            tmr1.Stop();
            //Start the enemy winner timer.
            tmrWinner.Start();

        }

        private void frmMain_Load(object sender, EventArgs e)
        {
        }
    }
}
