package  
{
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Stage;	
	import flash.system.fscommand;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	
	public class Main extends MovieClip 
	{
		// changeable variables
		var ball_speed_reset:int = 10;			// initial and reset value
		var paddle_speed:int = 10;
		var ball_speed_icrease:int = 3;
		
		// objects
		var game_field:Game_Field;
		var game_menu:Game_Menu;
		var left_paddle:Paddle;
		var right_paddle:Paddle;
		var ball_one:Ball;
		var ball_two:Ball;
		
		// general variables
		var ball_speed:int;
		var score_left:int = 0;
		var score_right:int = 0;
		var paddle_movement_left:int = 0; 		// used to store and delete the value of paddle_speed without losing it
		var paddle_movement_right:int = 0;
		var ball_one_angle:int;				
		var ball_two_angle:int;
		var ball_one_rads:Number;
		var ball_two_rads:Number;
		var ball_one_hit:Boolean;				// flags
		var ball_two_hit:Boolean;
		var game_start:Boolean;
		var in_menu:Boolean;
		var speed_up_mode:Boolean;
		var two_ball_mode:Boolean;
		
		// sounds:
		// music
		var sound_music:Sound = new Sound();
		var music_channel:SoundChannel = new SoundChannel();
		var music_position:Number = 0;
		var music_on:Boolean = true;
		// collision effect
		var sound_hit:Sound = new Sound();
		var sound_channel:SoundChannel = new SoundChannel();
		var sound_on:Boolean = true;
				
		public function Main() 
		{
			menu();
			sound_music.load(new URLRequest("Sound/Journey(144kbps).mp3"));
			sound_hit.load(new URLRequest("Sound/phaserUp6.mp3"));
		}
		
		// Menu functions
		function menu():void // Menu Call
		{
			game_menu = new Game_Menu;
			addChild(game_menu);
			game_menu.x = 0;
			game_menu.y = 0;
			
			game_menu.button_resume.addEventListener(MouseEvent.CLICK,on_button_resume_click);
			game_menu.button_new_game.addEventListener(MouseEvent.CLICK,on_button_new_game);
			game_menu.button_options.addEventListener(MouseEvent.CLICK,on_button_options_click);
			game_menu.button_high_scores.addEventListener(MouseEvent.CLICK,on_button_high_scores_click);
			game_menu.button_info.addEventListener(MouseEvent.CLICK,on_button_info_click);
			game_menu.button_exit.addEventListener(MouseEvent.CLICK,on_button_exit_click);
			game_menu.options_menu.checkbox_music.addEventListener(MouseEvent.CLICK,on_music_checkbox_click);
			game_menu.options_menu.checkbox_sound.addEventListener(MouseEvent.CLICK,on_sound_checkbox_click);
			
			// these objects are being hidden because they are not created dynamically and are visible by default
			game_menu.options_menu.visible = false;
			game_menu.one_player.visible = false;
			game_menu.two_players.visible = false;
			game_menu.two_players_normal.visible = false;
			game_menu.two_players_speed_up.visible = false;
			game_menu.two_players_two_ball.visible = false;
			
			game_menu.red_ball_one.visible = false;
			game_menu.red_ball_two.visible = false;
			game_menu.red_paddle_left.visible = false;
			game_menu.red_paddle_right.visible = false;
			
			if (music_on == true)
			{
				game_menu.options_menu.checkbox_music.gotoAndStop("StateV");
			}
			else
			{
				game_menu.options_menu.checkbox_music.gotoAndStop("StateX");
			}
			if (sound_on == true)
			{
				game_menu.options_menu.checkbox_sound.gotoAndStop("StateV");
			}
			else
			{
				game_menu.options_menu.checkbox_sound.gotoAndStop("StateX");
			}
			
			// pause functionality
			if (game_start == true)
			{
				game_menu.red_ball_one.visible = true
			    game_menu.red_ball_one.x = ball_one.x
			    game_menu.red_ball_one.y = ball_one.y
				game_menu.red_paddle_left.visible = true
			    game_menu.red_paddle_left.x = left_paddle.x
			    game_menu.red_paddle_left.y = left_paddle.y
				game_menu.red_paddle_right.visible = true
			    game_menu.red_paddle_right.x = right_paddle.x
			    game_menu.red_paddle_right.y = right_paddle.y
				if (two_ball_mode == true)
				{
					game_menu.red_ball_two.visible = true
					game_menu.red_ball_two.x = ball_two.x
				    game_menu.red_ball_two.y = ball_two.y
				}
			}		
		}
		
		function on_button_resume_click(event:MouseEvent):void  //RESUME
		{
			if (game_start == true)
			{
				removeChild(game_menu)
				
				addEventListener(Event.ENTER_FRAME, frame);
				stage.focus = this;
				in_menu = false;
				
				if (music_on == true)
			    {
			        music_channel = sound_music.play(music_position,9999);
			    }			
			}
		}
		
		function on_button_new_game(event:MouseEvent):void   //NEWGAME
		{
			if(game_menu.one_player.visible == false)
			{
				game_menu.one_player.visible = true;
				game_menu.two_players.visible = true;
				game_menu.options_menu.visible = false;
				
				game_menu.one_player.addEventListener(MouseEvent.CLICK,on_one_player_click);
				game_menu.two_players.addEventListener(MouseEvent.CLICK,on_two_players_click);
			}
			else
			{
				game_menu.one_player.visible = false;
				game_menu.two_players.visible = false;
				
				game_menu.two_players_normal.visible = false;      
			    game_menu.two_players_speed_up.visible = false;
			    game_menu.two_players_two_ball.visible = false;
				
				//game_menu.one_player.removeEventListener(MouseEvent.CLICK,on_one_player_click);
				//game_menu.two_players.removeEventListener(MouseEvent.CLICK,on_two_players_click);
			}
			
		}
		
		function on_one_player_click(event:MouseEvent):void
		{
			    
		}
		
		function on_two_players_click(event:MouseEvent):void
		{
            if (game_menu.two_players_normal.visible == false)
			{
				game_menu.two_players_normal.visible = true;
			    game_menu.two_players_speed_up.visible = true;
			    game_menu.two_players_two_ball.visible = true;
			}
			else
			{
				game_menu.two_players_normal.visible = false;
			    game_menu.two_players_speed_up.visible = false;
			    game_menu.two_players_two_ball.visible = false;					
			}
				game_menu.two_players_normal.addEventListener(MouseEvent.CLICK,on_two_players_normal_click);
				game_menu.two_players_speed_up.addEventListener(MouseEvent.CLICK,on_two_players_speed_up_click);
				game_menu.two_players_two_ball.addEventListener(MouseEvent.CLICK,on_two_players_two_ball_click);
		}	
		
		function on_two_players_normal_click(event:MouseEvent):void
		{
			two_ball_mode = false;
			speed_up_mode = false;
			new_game();
		}
				
		function on_two_players_speed_up_click(event:MouseEvent):void
		{
			speed_up_mode = true;
			two_ball_mode = false;
			new_game();
		}
			
		function on_two_players_two_ball_click(event:MouseEvent):void
		{
			two_ball_mode = true;
			speed_up_mode = false;
			new_game();
		}

		function on_button_options_click(event:MouseEvent):void   //OPTIONS
		{
			if(game_menu.options_menu.visible == false)
			{
				game_menu.options_menu.visible = true;
				game_menu.one_player.visible = false;
				game_menu.two_players.visible = false;
				game_menu.two_players_normal.visible = false;
			    game_menu.two_players_speed_up.visible = false;
			    game_menu.two_players_two_ball.visible = false;
			}
			else
			{
				game_menu.options_menu.visible = false;
				
				game_menu.two_players_normal.visible = false;
			    game_menu.two_players_speed_up.visible = false;
			    game_menu.two_players_two_ball.visible = false;
			}
		}
		
		function on_music_checkbox_click(event:MouseEvent):void
		{
			if (music_on == true)
			{
				game_menu.options_menu.checkbox_music.gotoAndStop("StateX");
				music_on = false;
			}
			else
			{
			    game_menu.options_menu.checkbox_music.gotoAndStop("StateV");
			    music_on = true;
			}				
		}
		
		function on_sound_checkbox_click(event:MouseEvent):void
		{
			if (sound_on == true)
			{
			    game_menu.options_menu.checkbox_sound.gotoAndStop("StateX");
			    sound_on = false;
			}
			else
			{
			    game_menu.options_menu.checkbox_sound.gotoAndStop("StateV");
			    sound_on = true;
			}				
		}
		
		function on_button_high_scores_click(event:MouseEvent):void   //HIGHSCORES
		{

		}	
		
		function on_button_info_click(event:MouseEvent):void   //INFO
		{
			
		}	
		
		function on_button_exit_click(event:MouseEvent):void   //EXIT
		{
			fscommand("quit");
		}
		
		// In game functions
		// memory leak somewhere when starting a new game over and over
		function new_game():void
		{
			removeChild(game_menu);
			
			addEventListener(Event.ENTER_FRAME, frame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,on_key_press_down);
			stage.addEventListener(KeyboardEvent.KEY_UP,on_key_press_up);
				
			game_field = new Game_Field; 
			addChild(game_field);
			game_field.x = 0;
			game_field.y = 0;
			
			left_paddle = new Paddle;
			addChild(left_paddle);
			left_paddle.x = 20;
			left_paddle.y = 200;
			
			right_paddle = new Paddle;
			addChild(right_paddle);
			right_paddle.x = 530;
			right_paddle.y = 200;
			
			ball_one = new Ball;
			addChild(ball_one);
			ball_one.x = 470;
			ball_one.y = 200;
			
			if (two_ball_mode == true)
			{
				ball_two = new Ball;
				addChild(ball_two);
				ball_two.x = 80;
				ball_two.y = 200;
			}
			
			ball_speed = ball_speed_reset; // so ball speed from the speed up mode doesn't transfer 
			
			score_left = 0;
			score_right = 0;
			//game_field.Score_Left.text = String(score_left);
			//game_field.Score_Right.text = String(score_right);
			// happens under frame as well.
			
			game_start = true;
			in_menu = false;
			
			right_scored_one();
			left_scored_two();
			
			stage.focus = this;
			
			if (music_on == true)
			{
			    var music_position:Number = 0;
			    music_channel = sound_music.play(music_position,9999);
			}
		}
		
		function frame(event:Event):void
		{			
			if(ball_one.x >400)
			{
				stage.focus = game_field.Score_Left;
			}
			
			ball_one.x = ball_one.x + Math.cos(ball_one_rads) * ball_speed; 
			ball_one.y = ball_one.y + Math.sin(ball_one_rads) * ball_speed;
			
			if (two_ball_mode == true)
			{
				ball_two.x = ball_two.x + Math.cos(ball_two_rads) * ball_speed; 
			    ball_two.y = ball_two.y + Math.sin(ball_two_rads) * ball_speed;
			}
				
			if (ball_one.x > 550) // Left Scored
			{
				score_left += 1
				game_field.Score_Left.text = String(score_left);
				right_scored_one()
				if (score_left > 9)
				{
					game_field.Score_Left.width = 40;
					game_field.Score_Left.x = 210
				}
			}
			
			if (two_ball_mode == true) // Left Scored
		    {
			    if (ball_two.x > 550)
				{
				    score_left += 1
				    game_field.Score_Left.text = String(score_left);
				    right_scored_two()
				    if (score_left > 9)
				    {
					    game_field.Score_Left.width = 40;
					    game_field.Score_Left.x = 210
				    }
				}
			}

			if (ball_one.x < 0) // Right Scored
			{
				score_right += 1
				game_field.Score_Right.text = String(score_right);
				left_scored_one()
				if (score_right >9)
				{
					game_field.Score_Right.width = 40;
				}
			}
			
			if (two_ball_mode == true)
			{
				if (ball_two.x < 0) // Right Scored
			    {
				    score_right += 1
				    game_field.Score_Right.text = String(score_right);
				    left_scored_two()
				    if (score_right >9)
				    {
					    game_field.Score_Right.width = 40;
				    }
			    }
			}
			
			// this prevents a bug where the ball bounces inside the racket
			if (ball_one.x > 100 && ball_one.x < 400)
			{
				ball_one_hit = false;
			}
			if (two_ball_mode == true)
			{
				if (ball_two.x > 100 && ball_two.x < 400)
			    {
				    ball_two_hit = false;
			    }
			}

			//bounce from racket
			if (left_paddle.hitTestObject(ball_one) && ball_one_hit == false )
			{
				angleX = 360 - ball_one_angle;
				ball_one_angle = 180 + angleX;
				ball_one_rads = ball_one_angle * Math.PI  / 180;
				ball_one_hit = true;
				
				if (sound_on == true)
				{
				    sound_channel = sound_hit.play(0,1);					
				}
				if (speed_up_mode == true)
				{
					ball_speed = ball_speed + ball_speed_icrease;
				}
			}
			
			if (two_ball_mode == true)
			{
			    if (left_paddle.hitTestObject(ball_two) && ball_two_hit == false )
			    {
				    angleXTwo = 360 - ball_two_angle;
				    ball_two_angle = 180 + angleXTwo;
				    ball_two_rads = ball_two_angle * Math.PI  / 180;
				    ball_two_hit = true;
				
				    if (sound_on == true)
				    {
				        sound_channel = sound_hit.play(0,1);					
				    }
				    if (speed_up_mode == true)
				    {
					    ball_speed = ball_speed + ball_speed_icrease;
				    }
			    }
			}
			
			if (right_paddle.hitTestObject(ball_one) && ball_one_hit == false )
			{
				angleX = 180 - ball_one_angle;
				ball_one_angle = 0 + angleX;
				ball_one_rads = ball_one_angle * Math.PI  / 180;
				ball_one_hit = true;
				
				if (sound_on == true)
				{
				    sound_channel = sound_hit.play(0,1);					
				}
				if (speed_up_mode == true)
				{
					ball_speed = ball_speed + ball_speed_icrease;
				}
			}
			
			if (two_ball_mode == true)
			{
			    if (right_paddle.hitTestObject(ball_two) && ball_two_hit == false )
			    {
				    angleXTwo = 180 - ball_two_angle;
				    ball_two_angle = 0 + angleXTwo;
				    ball_two_rads = ball_two_angle * Math.PI  / 180;
				    ball_two_hit = true;
				
				    if (sound_on == true)
				    {
				        sound_channel = sound_hit.play(0,1);					
				    }
				    if (speed_up_mode == true)
				    {
					    ball_speed = ball_speed + ball_speed_icrease;
				    }				
			    }
			}
			
			//bounce from borders
			if (ball_one.y <= 0) //top
			{
				var angleX:Number; //insignificant name
				
				angleX = 360 - ball_one_angle;
				ball_one_angle = 0 + angleX;
				ball_one_rads = ball_one_angle * Math.PI  / 180;
			}
			
			if (ball_one.y >= game_field.height) //bottom
			{
				var angleY:Number;
				
				angleY = ball_one_angle;
				ball_one_angle = 0 - angleY;
				ball_one_rads = ball_one_angle * Math.PI  / 180;
			}
			
			if (two_ball_mode == true)
			{
			    if (ball_two.y <= 0) //top
			    {
				    var angleXTwo:Number; //insignificant name
				
				    angleXTwo = 360 - ball_two_angle;
				    ball_two_angle = 0 + angleXTwo;
				    ball_two_rads = ball_two_angle * Math.PI  / 180;
			    }
			    if (ball_two.y >= game_field.height) //bottom
			    {
				    var angleYTwo:Number;
				
				    angleYTwo = ball_two_angle;
				    ball_two_angle = 0 - angleYTwo;
				    ball_two_rads = ball_two_angle * Math.PI  / 180;
			    }
			}
			
			// moves the paddles if w/s/up/down are pressed down, if pressed up adds 0s
			left_paddle.y += paddle_movement_left;
		    right_paddle.y += paddle_movement_right;
			
			//top border
			if (left_paddle.y < 20)
			{
				left_paddle.y = 20;
			}
			//bottom border
			if (left_paddle.y > 380)
			{
				left_paddle.y = 380;
			}
			//top border
			if (right_paddle.y < 20)
			{
				right_paddle.y = 20;
			}
			//bottom border
			if (right_paddle.y > 380)
			{
				right_paddle.y = 380;
			}
		}
		
		function on_key_press_up(event:KeyboardEvent):void 
		{
			if(event.keyCode == Keyboard.W)
			{
				paddle_movement_left = 0;
			}
			if(event.keyCode == Keyboard.S)
			{
				paddle_movement_left = 0;
			}
			if(event.keyCode == Keyboard.UP)
			{
				paddle_movement_right = 0;
			}
			if(event.keyCode == Keyboard.DOWN)
			{
				paddle_movement_right = 0;
			}
		}
		
		function on_key_press_down(event:KeyboardEvent):void 
		{
			if(event.keyCode == Keyboard.W) //left paddle moves up
			{
				paddle_movement_left = -paddle_speed;
				//left_paddle.y += -paddle_speed
			}
			if(event.keyCode == Keyboard.S) //left paddle  moves down
			{
				paddle_movement_left = paddle_speed;
				//left_paddle.y += +paddle_speed
			}
			if(event.keyCode == Keyboard.UP) //right paddle moves up
			{
				paddle_movement_right = -paddle_speed;
				//right_paddle.y += -paddle_speed
			}
			if(event.keyCode == Keyboard.DOWN) //right paddle moves down
			{
				paddle_movement_right = paddle_speed;
				//right_paddle.y += +paddle_speed
			}
			if(event.keyCode == Keyboard.ESCAPE)
			{			
			    if (in_menu == false)
				{
				
					menu();
					
					in_menu = true;
					
					removeEventListener(Event.ENTER_FRAME, frame);
				
					if (music_on == true)
					{
						music_position = music_channel.position;
						music_channel.stop();
					}
			    }
				else
				{
					removeChild(game_menu)
				
				    addEventListener(Event.ENTER_FRAME, frame);
				    stage.focus = this;
					in_menu = false;
					
				    if (music_on == true)
			        {
			            music_channel = sound_music.play(music_position,9999);
			        }
				}
		    }
		}
		
		function right_scored_one():void // ball reset from Right to Left   //Quadrant 2 and 3 (Top Left & Bottom Left)
		{
			ball_one.x = 470;
			ball_one.y = 200;
			
			var num = Math.round(Math.random()* 1 + 0);
			if (num == 0)
			{
				ball_one_angle = Math.round(Math.random()* 60 + 195);  //Q3 
			}
			else 
			{
				ball_one_angle = Math.round(Math.random()* 60 + 105);  //Q2
			}
			
			ball_one_rads = ball_one_angle * Math.PI  / 180;
			
			if (speed_up_mode == true)
			{
				ball_speed = ball_speed_reset
			}
		}
		
		function right_scored_two():void
		{
		    if (two_ball_mode == true)  //two_ball_mode
			{
			    ball_two.x = 470;
			    ball_two.y = 200;
			
			    var numTwo = Math.round(Math.random()* 1 + 0);
			    if (numTwo == 0)
			    {
				    ball_two_angle = Math.round(Math.random()* 60 + 195);  //Q3  
			    }
			    else 
			    {
				    ball_two_angle = Math.round(Math.random()* 60 + 105);  //Q2
			    }
			
			    ball_two_rads = ball_two_angle * Math.PI  / 180;
			 }
			 
			 if (speed_up_mode == true)
			 {
				 ball_speed = ball_speed_reset
			 }
		}
		
		function left_scored_one():void // ball reset from Left to Right     //Q 1 & 4 (Top Rright & Bottom Right)
		{
			ball_one.x = 80;
			ball_one.y = 200;
			
			var num = Math.round(Math.random()* 1 + 0);
			if (num == 0)
			{
				ball_one_angle = Math.round(Math.random()* 60 + 285);  //Q4
			}
			else 
			{
				ball_one_angle = Math.round(Math.random()* 60 + 15);  //Q1
			}
			
			ball_one_rads = ball_one_angle * Math.PI  / 180;
			
			if (speed_up_mode == true)
			{
				ball_speed = ball_speed_reset
			}
		}
		
		function left_scored_two():void
		{
			if (two_ball_mode == true) //two_ball_mode
			{
			    ball_two.x = 80;
			    ball_two.y = 200;
			
			    var numTwo = Math.round(Math.random()* 1 + 0);
			    if (numTwo == 0)
			    {
				    ball_two_angle = Math.round(Math.random()* 60 + 285);  //Q4
			    }
			    else 
			    {
				    ball_two_angle = Math.round(Math.random()* 60 + 15);  //Q1
			    }
			
			    ball_two_rads = ball_two_angle * Math.PI  / 180;
				
				if (speed_up_mode == true)
			    {
				    ball_speed = ball_speed_reset
			    }
			}
		}
	}	
}