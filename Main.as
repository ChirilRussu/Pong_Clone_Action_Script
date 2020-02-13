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
		//changeable variables
		var ball_speed:int = -10;
		var paddle_speed:int = 10;
		var ball_speed_icrease:int = 3;
		
		//objects
		var background_stage:Background_Stage;
		var game_menu:Game_Menu;
		var left_paddle:Paddle;
		var right_paddle:Paddle;
		var ball_one:Ball;
		var ballTwo:Ball;
		
		//storing variables
		var left_score:int = 0;
		var right_score:int = 0;
		var paddle_movement_left:int = 0; 		// used to store and overwrite paddle_speed without losing its value
		var paddle_movement_right:int = 0;
		var first_ball_angle:int;				
		var second_ball_angle:int;
		var rads:Number;                    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		var radsTwo:Number;					////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		var first_ball_hit:Boolean;				// hit detection flags
		var second_ball_hit:Boolean;
		var game_start:Boolean;
		var in_menu:Boolean;
		var soeed_up_mode:Boolean;
		var two_ball_mode:Boolean;
		
		//sounds
		//music
		var mySound:Sound = new Sound();
		var myChannel:SoundChannel = new SoundChannel();
		var lastPosition:Number = 0;
		var musicOn:Boolean = true;
		//collision effect
		var mySound1:Sound = new Sound();
		var myChannel1:SoundChannel = new SoundChannel();
		var soundsOn:Boolean = true;
				
		public function Main() 
		{
			menu();
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyPressDown);
			stage.addEventListener(KeyboardEvent.KEY_UP,onKeyPressUp);
			mySound.load(new URLRequest("Journey(144kbps).mp3"));
			mySound1.load(new URLRequest("phaserUp6.mp3"));
		}
		
		function menu():void //Menu Call
		{			
			game_menu = new Game_Menu;
			addChild(game_menu);
			game_menu.x = 0;
			game_menu.y = 0;
			
			game_menu.resumeButton.addEventListener(MouseEvent.CLICK,onResumeButtonClick);
			game_menu.newGameButton.addEventListener(MouseEvent.CLICK,onNewGameButtonClick);
			game_menu.optionsButton.addEventListener(MouseEvent.CLICK,onOptionsButtonClick);
			game_menu.highScoresButton.addEventListener(MouseEvent.CLICK,onHighScoresButtonClick);
			game_menu.infoButton.addEventListener(MouseEvent.CLICK,onInfoButtonClick);
			game_menu.exitButton.addEventListener(MouseEvent.CLICK,onExitButtonClick);
			game_menu.optionsMenu.firstCheckBox.addEventListener(MouseEvent.CLICK,onMusicChckBoxClick);
			game_menu.optionsMenu.secondCheckBox.addEventListener(MouseEvent.CLICK,onSoundsChckBoxClick);
			
			game_menu.optionsMenu.visible = false;
			game_menu.onePlayer.visible = false;
			game_menu.twoPlayers.visible = false;
			game_menu.normal.visible = false;
			game_menu.speedUp.visible = false;
			game_menu.twoBall.visible = false;
			
			if (musicOn == true)
			{
				game_menu.optionsMenu.firstCheckBox.gotoAndStop("StateV");
			}
			else
			{
				game_menu.optionsMenu.firstCheckBox.gotoAndStop("StateX");
			}
			if (soundsOn == true)
			{
				game_menu.optionsMenu.secondCheckBox.gotoAndStop("StateV");
			}
			else
			{
				game_menu.optionsMenu.secondCheckBox.gotoAndStop("StateX");
			}
			
			game_menu.redBall.visible = false;
			game_menu.redPlayer.visible = false;
			game_menu.redAI.visible = false;
			if (game_start == true)
			{
				game_menu.redBall.visible = true
			    game_menu.redBall.x = ball_one.x
			    game_menu.redBall.y = ball_one.y
				game_menu.redPlayer.visible = true
			    game_menu.redPlayer.x = left_paddle.x
			    game_menu.redPlayer.y = left_paddle.y
				game_menu.redAI.visible = true
			    game_menu.redAI.x = right_paddle.x
			    game_menu.redAI.y = right_paddle.y
				if (two_ball_mode == true)
				{
					game_menu.redBallTwo.x = ballTwo.x
				    game_menu.redBallTwo.y = ballTwo.y
				}
				else
				{
					game_menu.redBallTwo.x = - 20
				    game_menu.redBallTwo.y = - 20
				}
			}
			if (musicOn == true)
			{
			    lastPosition = myChannel.position;
			    myChannel.stop();
			}
		}
		
		function onResumeButtonClick(event:MouseEvent):void  //RESUME
		{
			if (game_start == true)
			{
				removeChild(game_menu)
				
				addEventListener(Event.ENTER_FRAME, frame);
				stage.focus = this;
				in_menu = false;
				
				if (musicOn == true)
			    {
			        myChannel = mySound.play(lastPosition,9999);
			    }			
			}
		}
		function onNewGameButtonClick(event:MouseEvent):void   //NEWGAME
		{
			if(game_menu.onePlayer.visible == false)
			{
				game_menu.onePlayer.visible = true;
				game_menu.twoPlayers.visible = true;
				game_menu.optionsMenu.visible = false;
			}
			else
			{
				game_menu.onePlayer.visible = false;
				game_menu.twoPlayers.visible = false;
				
				game_menu.normal.visible = false;      
			    game_menu.speedUp.visible = false;
			    game_menu.twoBall.visible = false;
			}
			game_menu.onePlayer.addEventListener(MouseEvent.CLICK,onOneplayerClick);
			game_menu.twoPlayers.addEventListener(MouseEvent.CLICK,onTwoplayersClick);
		}
		    function onOneplayerClick(event:MouseEvent):void
		    {
			    
		    }
		    function onTwoplayersClick(event:MouseEvent):void
		    {
                if (game_menu.normal.visible == false)
				{
					game_menu.normal.visible = true;
			        game_menu.speedUp.visible = true;
			        game_menu.twoBall.visible = true;
				}
				else
				{
					game_menu.normal.visible = false;
			        game_menu.speedUp.visible = false;
			        game_menu.twoBall.visible = false;					
				}
				game_menu.normal.addEventListener(MouseEvent.CLICK,onNormalClick);
				game_menu.speedUp.addEventListener(MouseEvent.CLICK,onSpeedUpClick);
				game_menu.twoBall.addEventListener(MouseEvent.CLICK,onTwoBallClick);
		    }		
			    function onNormalClick(event:MouseEvent):void
				{
					two_ball_mode = false;
					soeed_up_mode = false;
					ball_speed = -10; // speed reset
					newGame();
				}
				function onSpeedUpClick(event:MouseEvent):void
				{
					soeed_up_mode = true;
					two_ball_mode = false;
					ball_speed = -10; // speed reset
					newGame();
				}
				function onTwoBallClick(event:MouseEvent):void
				{
					two_ball_mode = true;
					soeed_up_mode = false;
					ball_speed = -10; // speed reset
					newGame();
				}

		function onOptionsButtonClick(event:MouseEvent):void   //OPTIONS
		{
			if(game_menu.optionsMenu.visible == false)
			{
				game_menu.optionsMenu.visible = true;
				game_menu.onePlayer.visible = false;
				game_menu.twoPlayers.visible = false;
				game_menu.normal.visible = false;
			    game_menu.speedUp.visible = false;
			    game_menu.twoBall.visible = false;
			}
			else
			{
				game_menu.optionsMenu.visible = false;
				
				game_menu.normal.visible = false;
			    game_menu.speedUp.visible = false;
			    game_menu.twoBall.visible = false;
			}
		}
		    function onMusicChckBoxClick(event:MouseEvent):void
		    {
			    if (musicOn == true)
				    {
					    game_menu.optionsMenu.firstCheckBox.gotoAndStop("StateX");
					    musicOn = false;
				    }
			    else
				    {
					    game_menu.optionsMenu.firstCheckBox.gotoAndStop("StateV");
					    musicOn = true;
				    }				
		    }
		    function onSoundsChckBoxClick(event:MouseEvent):void
		    {
			    if (soundsOn == true)
				    {
					    game_menu.optionsMenu.secondCheckBox.gotoAndStop("StateX");
					    soundsOn = false;
				    }
			    else
				    {
					    game_menu.optionsMenu.secondCheckBox.gotoAndStop("StateV");
					    soundsOn = true;
				    }				
		}
		function onHighScoresButtonClick(event:MouseEvent):void   //HIGHSCORES
		{

		}		
		function onInfoButtonClick(event:MouseEvent):void   //INFO
		{
			
		}		
		function onExitButtonClick(event:MouseEvent):void   //EXIT
		{
			fscommand("quit");
		}
		function newGame():void
		{
			removeChild(game_menu);
			
			addEventListener(Event.ENTER_FRAME, frame);
			
			background_stage = new Background_Stage; 
			addChild(background_stage);
			background_stage.x = 0;
			background_stage.y = 0;
			
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
				ballTwo = new Ball;
				addChild(ballTwo);
				ballTwo.x = 80;
				ballTwo.y = 200;
			}
			
			left_score = 0;
			right_score = 0;
			background_stage.Left_Score.text = String(left_score);
			background_stage.Right_Score.text = String(right_score);
			
			game_start = true;
			in_menu = false;
			
			aiScored();
			playerScoredTwo();
			
			stage.focus = this;
			
			if (musicOn == true)
			{
			    var lastPosition:Number = 0;
			    myChannel = mySound.play(lastPosition,9999);
			}
		}
		function frame(event:Event):void
		{			
			if(ball_one.x >400)
			{
				stage.focus = background_stage.Left_Score;
			}
			
			ball_one.x = ball_one.x + Math.cos(rads) * ball_speed; 
			ball_one.y = ball_one.y + Math.sin(rads) * ball_speed;
			
			if (two_ball_mode == true)
			{
				ballTwo.x = ballTwo.x + Math.cos(radsTwo) * ball_speed; 
			    ballTwo.y = ballTwo.y + Math.sin(radsTwo) * ball_speed;
			}
				
			if (ball_one.x > 550) // AI Score
			{
				left_score += 1
				background_stage.Left_Score.text = String(left_score);
				aiScored()
				if (left_score > 9)
				{
					background_stage.Left_Score.width = 40;
					background_stage.Left_Score.x = 210
				}
			}
			
			if (two_ball_mode == true)
		    {
			    if (ballTwo.x > 550)
				{
				    left_score += 1
				    background_stage.Left_Score.text = String(left_score);
				    aiScoredTwo()
				    if (left_score > 9)
				    {
					    background_stage.Left_Score.width = 40;
					    background_stage.Left_Score.x = 210
				    }
				}
			}

			if (ball_one.x < 0) // Player Score
			{
				right_score += 1
				background_stage.Right_Score.text = String(right_score);
				playerScored()
				if (right_score >9)
				{
					background_stage.Right_Score.width = 40;
				}
			}
			
			if (two_ball_mode == true)
			{
				if (ballTwo.x < 0) // AI Score
			    {
				    right_score += 1
				    background_stage.Right_Score.text = String(right_score);
				    playerScoredTwo()
				    if (right_score >9)
				    {
					    background_stage.Right_Score.width = 40;
				    }
			    }
			}
			
			// this prevents a bug where the ball bounces inside the racket
			if (ball_one.x > 100 && ball_one.x < 400)
			{
				first_ball_hit = false;
			}
			if (two_ball_mode == true)
			{
				if (ballTwo.x > 100 && ballTwo.x < 400)
			    {
				    second_ball_hit = false;
			    }
			}

			//bounce from racket
			if (left_paddle.hitTestObject(ball_one) && first_ball_hit == false )
			{
				angleX = 360 - first_ball_angle;
				first_ball_angle = 180 + angleX;
				rads = first_ball_angle * Math.PI  / 180;
				first_ball_hit = true;
				
				if (soundsOn == true)
				{
				    myChannel1 = mySound1.play(0,1);					
				}
				if (soeed_up_mode == true)
				{
					ball_speed = ball_speed - ball_speed_icrease;
				}
			}
			if (two_ball_mode == true)
			{
			    if (left_paddle.hitTestObject(ballTwo) && second_ball_hit == false )
			    {
				    angleXTwo = 360 - second_ball_angle;
				    second_ball_angle = 180 + angleXTwo;
				    radsTwo = second_ball_angle * Math.PI  / 180;
				    second_ball_hit = true;
				
				    if (soundsOn == true)
				    {
				        myChannel1 = mySound1.play(0,1);					
				    }
				    if (soeed_up_mode == true)
				    {
					    ball_speed = ball_speed - ball_speed_icrease;
				    }
			    }
			}
			if (right_paddle.hitTestObject(ball_one) && first_ball_hit == false )
			{
				angleX = 180 - first_ball_angle;
				first_ball_angle = 0 + angleX;
				rads = first_ball_angle * Math.PI  / 180;
				first_ball_hit = true;
				
				if (soundsOn == true)
				{
				    myChannel1 = mySound1.play(0,1);					
				}
				if (soeed_up_mode == true)
				{
					ball_speed = ball_speed - ball_speed_icrease;
				}
			}
			if (two_ball_mode == true)
			{
			    if (right_paddle.hitTestObject(ballTwo) && second_ball_hit == false )
			    {
				    angleXTwo = 180 - second_ball_angle;
				    second_ball_angle = 0 + angleXTwo;
				    radsTwo = second_ball_angle * Math.PI  / 180;
				    second_ball_hit = true;
				
				    if (soundsOn == true)
				    {
				        myChannel1 = mySound1.play(0,1);					
				    }
				    if (soeed_up_mode == true)
				    {
					    ball_speed = ball_speed - ball_speed_icrease;
				    }				
			    }
			}
			//bounce from borders
			if (ball_one.y <= 0) //top
			{
				var angleX:Number; //insignificant name
				
				angleX = 360 - first_ball_angle;
				first_ball_angle = 0 + angleX;
				rads = first_ball_angle * Math.PI  / 180;
			}
			if (ball_one.y >= background_stage.height) //bottom
			{
				var angleY:Number;
				
				angleY = first_ball_angle;
				first_ball_angle = 0 - angleY;
				rads = first_ball_angle * Math.PI  / 180;
			}
			if (two_ball_mode == true)
			{
			    if (ballTwo.y <= 0) //top
			    {
				    var angleXTwo:Number; //insignificant name
				
				    angleXTwo = 360 - second_ball_angle;
				    second_ball_angle = 0 + angleXTwo;
				    radsTwo = second_ball_angle * Math.PI  / 180;
			    }
			    if (ballTwo.y >= background_stage.height) //bottom
			    {
				    var angleYTwo:Number;
				
				    angleYTwo = second_ball_angle;
				    second_ball_angle = 0 - angleYTwo;
				    radsTwo = second_ball_angle * Math.PI  / 180;
			    }
			}
			
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
		function onKeyPressUp(event:KeyboardEvent):void 
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
		function onKeyPressDown(event:KeyboardEvent):void 
		{
			if(event.keyCode == Keyboard.W) //player moves up
			{
				paddle_movement_left = -paddle_speed;
				//left_paddle.y += -paddle_speed
			}
			if(event.keyCode == Keyboard.S) //player moves down
			{
				paddle_movement_left = paddle_speed;
				//left_paddle.y += +paddle_speed
			}
			if(event.keyCode == Keyboard.UP) //player moves up
			{
				paddle_movement_right = -paddle_speed;
				//right_paddle.y += -paddle_speed
			}
			if(event.keyCode == Keyboard.DOWN) //player moves down
			{
				paddle_movement_right = paddle_speed;
				//right_paddle.y += +paddle_speed
			}
			if(event.keyCode == Keyboard.ESCAPE)
			{			
			    if (in_menu == false)
				{
					removeEventListener(Event.ENTER_FRAME, frame);
				
				    menu();
					in_menu = true;
			    }
				else
				{
					removeChild(game_menu)
				
				    addEventListener(Event.ENTER_FRAME, frame);
				    stage.focus = this;
					in_menu = false;
					
				    if (musicOn == true)
			        {
			            myChannel = mySound.play(lastPosition,9999);
			        }
				}
		    }
		}
		function aiScored():void //ball reset from AI to Player   //Quadrant 2 and 3 (BL & TL)
		{
			ball_one.x = 470;
			ball_one.y = 200;
			
			var num = Math.round(Math.random()* 1 + 0);
			if (num == 0)
			{
				first_ball_angle = Math.round(Math.random()* 60 + 285);  //Q4 
			}
			else 
			{
				first_ball_angle = Math.round(Math.random()* 60 + 15);  //Q1
			}
			
			rads = first_ball_angle * Math.PI  / 180;
			
			if (soeed_up_mode == true)
			{
				ball_speed = -10
			}
		}
		function aiScoredTwo():void
		{
		    if (two_ball_mode == true)  //two_ball_mode
			{
			    ballTwo.x = 470;
			    ballTwo.y = 200;
			
			    var numTwo = Math.round(Math.random()* 1 + 0);
			    if (numTwo == 0)
			    {
				    second_ball_angle = Math.round(Math.random()* 60 + 285);  //Q4 
			    }
			    else 
			    {
				    second_ball_angle = Math.round(Math.random()* 60 + 15);  //Q1
			    }
			
			    radsTwo = second_ball_angle * Math.PI  / 180;
			 }
			 
			 if (soeed_up_mode == true)
			 {
				 ball_speed = -10
			 }
		}
		function playerScored():void //ball reset from Player to AI     //Q 1 & 4 (BR & TR)
		{
			ball_one.x = 80;
			ball_one.y = 200;
			
			var num = Math.round(Math.random()* 1 + 0);
			if (num == 0)
			{
				first_ball_angle = Math.round(Math.random()* 60 + 195);  //Q3
			}
			else 
			{
				first_ball_angle = Math.round(Math.random()* 60 + 105);  //Q2
			}
			
			rads = first_ball_angle * Math.PI  / 180;
			
			if (soeed_up_mode == true)
			{
				ball_speed = -10
			}
		}
		function playerScoredTwo():void
		{
			if (two_ball_mode == true) //two_ball_mode
			{
			    ballTwo.x = 80;
			    ballTwo.y = 200;
			
			    var numTwo = Math.round(Math.random()* 1 + 0);
			    if (numTwo == 0)
			    {
				    second_ball_angle = Math.round(Math.random()* 60 + 195);  //Q3
			    }
			    else 
			    {
				    second_ball_angle = Math.round(Math.random()* 60 + 105);  //Q2
			    }
			
			    radsTwo = second_ball_angle * Math.PI  / 180;
				
				if (soeed_up_mode == true)
			    {
				    ball_speed = -10
			    }
			}
		}
	}	
}