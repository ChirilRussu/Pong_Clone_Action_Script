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
		var ball_speed:int = -10;    			// ball speed
		var paddle_speed:int = 10;  			// player and ai movement speed
		var ball_speed_icrease:int = 3;         // SpeedUp speed 
		
		//objects
		var backgrnd:Backgrnd;
		var left_paddle:Left_Paddle;
		var right_paddle:Right_Paddle;
		var ball:Ball;
		var gameMenu:GameMenu;
		var ballTwo:Ball;
		
		//storing variables
		var playerscore:int = 0;
		var aiscore:int = 0;
		var controlspeedP:int = 0;
		var controlspeedA:int = 0;
		var angle:int;
		var angleTwo:int;
		var rads:Number;
		var radsTwo:Number;
		var hitHappens:Boolean;
		var hitHappensTwo:Boolean;
		var GameStarted:Boolean;
		var InMenu:Boolean;
		var SpeedUp:Boolean;
		var TwoBall:Boolean;
		
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
			gameMenu = new GameMenu;
			addChild(gameMenu);
			gameMenu.x = 0;
			gameMenu.y = 0;
			
			gameMenu.resumeButton.addEventListener(MouseEvent.CLICK,onResumeButtonClick);
			gameMenu.newGameButton.addEventListener(MouseEvent.CLICK,onNewGameButtonClick);
			gameMenu.optionsButton.addEventListener(MouseEvent.CLICK,onOptionsButtonClick);
			gameMenu.highScoresButton.addEventListener(MouseEvent.CLICK,onHighScoresButtonClick);
			gameMenu.infoButton.addEventListener(MouseEvent.CLICK,onInfoButtonClick);
			gameMenu.exitButton.addEventListener(MouseEvent.CLICK,onExitButtonClick);
			gameMenu.optionsMenu.firstCheckBox.addEventListener(MouseEvent.CLICK,onMusicChckBoxClick);
			gameMenu.optionsMenu.secondCheckBox.addEventListener(MouseEvent.CLICK,onSoundsChckBoxClick);
			
			gameMenu.optionsMenu.visible = false;
			gameMenu.onePlayer.visible = false;
			gameMenu.twoPlayers.visible = false;
			gameMenu.normal.visible = false;
			gameMenu.speedUp.visible = false;
			gameMenu.twoBall.visible = false;
			
			if (musicOn == true)
			{
				gameMenu.optionsMenu.firstCheckBox.gotoAndStop("StateV");
			}
			else
			{
				gameMenu.optionsMenu.firstCheckBox.gotoAndStop("StateX");
			}
			if (soundsOn == true)
			{
				gameMenu.optionsMenu.secondCheckBox.gotoAndStop("StateV");
			}
			else
			{
				gameMenu.optionsMenu.secondCheckBox.gotoAndStop("StateX");
			}
			
			gameMenu.redBall.visible = false;
			gameMenu.redPlayer.visible = false;
			gameMenu.redAI.visible = false;
			if (GameStarted == true)
			{
				gameMenu.redBall.visible = true
			    gameMenu.redBall.x = ball.x
			    gameMenu.redBall.y = ball.y
				gameMenu.redPlayer.visible = true
			    gameMenu.redPlayer.x = left_paddle.x
			    gameMenu.redPlayer.y = left_paddle.y
				gameMenu.redAI.visible = true
			    gameMenu.redAI.x = right_paddle.x
			    gameMenu.redAI.y = right_paddle.y
				if (TwoBall == true)
				{
					gameMenu.redBallTwo.x = ballTwo.x
				    gameMenu.redBallTwo.y = ballTwo.y
				}
				else
				{
					gameMenu.redBallTwo.x = - 20
				    gameMenu.redBallTwo.y = - 20
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
			if (GameStarted == true)
			{
				removeChild(gameMenu)
				
				addEventListener(Event.ENTER_FRAME, frame);
				stage.focus = this;
				InMenu = false;
				
				if (musicOn == true)
			    {
			        myChannel = mySound.play(lastPosition,9999);
			    }			
			}
		}
		function onNewGameButtonClick(event:MouseEvent):void   //NEWGAME
		{
			if(gameMenu.onePlayer.visible == false)
			{
				gameMenu.onePlayer.visible = true;
				gameMenu.twoPlayers.visible = true;
				gameMenu.optionsMenu.visible = false;
			}
			else
			{
				gameMenu.onePlayer.visible = false;
				gameMenu.twoPlayers.visible = false;
				
				gameMenu.normal.visible = false;      
			    gameMenu.speedUp.visible = false;
			    gameMenu.twoBall.visible = false;
			}
			gameMenu.onePlayer.addEventListener(MouseEvent.CLICK,onOneplayerClick);
			gameMenu.twoPlayers.addEventListener(MouseEvent.CLICK,onTwoplayersClick);
		}
		    function onOneplayerClick(event:MouseEvent):void
		    {
			    
		    }
		    function onTwoplayersClick(event:MouseEvent):void
		    {
                if (gameMenu.normal.visible == false)
				{
					gameMenu.normal.visible = true;
			        gameMenu.speedUp.visible = true;
			        gameMenu.twoBall.visible = true;
				}
				else
				{
					gameMenu.normal.visible = false;
			        gameMenu.speedUp.visible = false;
			        gameMenu.twoBall.visible = false;					
				}
				gameMenu.normal.addEventListener(MouseEvent.CLICK,onNormalClick);
				gameMenu.speedUp.addEventListener(MouseEvent.CLICK,onSpeedUpClick);
				gameMenu.twoBall.addEventListener(MouseEvent.CLICK,onTwoBallClick);
		    }		
			    function onNormalClick(event:MouseEvent):void
				{
					TwoBall = false;
					SpeedUp = false;
					ball_speed = -10; // speed reset
					newGame();
				}
				function onSpeedUpClick(event:MouseEvent):void
				{
					SpeedUp = true;
					TwoBall = false;
					ball_speed = -10; // speed reset
					newGame();
				}
				function onTwoBallClick(event:MouseEvent):void
				{
					TwoBall = true;
					SpeedUp = false;
					ball_speed = -10; // speed reset
					newGame();
				}

		function onOptionsButtonClick(event:MouseEvent):void   //OPTIONS
		{
			if(gameMenu.optionsMenu.visible == false)
			{
				gameMenu.optionsMenu.visible = true;
				gameMenu.onePlayer.visible = false;
				gameMenu.twoPlayers.visible = false;
				gameMenu.normal.visible = false;
			    gameMenu.speedUp.visible = false;
			    gameMenu.twoBall.visible = false;
			}
			else
			{
				gameMenu.optionsMenu.visible = false;
				
				gameMenu.normal.visible = false;
			    gameMenu.speedUp.visible = false;
			    gameMenu.twoBall.visible = false;
			}
		}
		    function onMusicChckBoxClick(event:MouseEvent):void
		    {
			    if (musicOn == true)
				    {
					    gameMenu.optionsMenu.firstCheckBox.gotoAndStop("StateX");
					    musicOn = false;
				    }
			    else
				    {
					    gameMenu.optionsMenu.firstCheckBox.gotoAndStop("StateV");
					    musicOn = true;
				    }				
		    }
		    function onSoundsChckBoxClick(event:MouseEvent):void
		    {
			    if (soundsOn == true)
				    {
					    gameMenu.optionsMenu.secondCheckBox.gotoAndStop("StateX");
					    soundsOn = false;
				    }
			    else
				    {
					    gameMenu.optionsMenu.secondCheckBox.gotoAndStop("StateV");
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
			removeChild(gameMenu);
			
			addEventListener(Event.ENTER_FRAME, frame);
			
			backgrnd = new Backgrnd; 
			addChild(backgrnd);
			backgrnd.x = 0;
			backgrnd.y = 0;
			
			left_paddle = new Left_Paddle;
			addChild(left_paddle);
			left_paddle.x = 20;
			left_paddle.y = 200;
			
			right_paddle = new Right_Paddle;
			addChild(right_paddle);
			right_paddle.x = 530;
			right_paddle.y = 200;
			
			ball = new Ball;
			addChild(ball);
			ball.x = 470;
			ball.y = 200;
			
			if (TwoBall == true)
			{
				ballTwo = new Ball;
				addChild(ballTwo);
				ballTwo.x = 80;
				ballTwo.y = 200;
			}
			
			playerscore = 0;
			aiscore = 0;
			backgrnd.PlayerScore.text = String(playerscore);
			backgrnd.AIScore.text = String(aiscore);
			
			GameStarted = true;
			InMenu = false;
			
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
			if(ball.x >400)
			{
				stage.focus = backgrnd.PlayerScore;
			}
			
			ball.x = ball.x + Math.cos(rads) * ball_speed; 
			ball.y = ball.y + Math.sin(rads) * ball_speed;
			
			if (TwoBall == true)
			{
				ballTwo.x = ballTwo.x + Math.cos(radsTwo) * ball_speed; 
			    ballTwo.y = ballTwo.y + Math.sin(radsTwo) * ball_speed;
			}
				
			
			if (ball.x > 550) // AI Score
			{
				playerscore += +1
				backgrnd.PlayerScore.text = String(playerscore);
				aiScored()
				if (playerscore > 9)
				{
					backgrnd.PlayerScore.width = 40;
					backgrnd.PlayerScore.x = 210
				}
			}
			
			if (TwoBall == true)
		    {
			    if (ballTwo.x > 550)
				{
				    playerscore += +1
				    backgrnd.PlayerScore.text = String(playerscore);
				    aiScoredTwo()
				    if (playerscore > 9)
				    {
					    backgrnd.PlayerScore.width = 40;
					    backgrnd.PlayerScore.x = 210
				    }
				}
			}
				
			if (ball.x < 0) // Player Score
			{
				aiscore += +1
				backgrnd.AIScore.text = String(aiscore);
				playerScored()
				if (aiscore >9)
				{
					backgrnd.AIScore.width = 40;
				}
			}
			
			if (TwoBall == true)
			{
				if (ballTwo.x < 0) // AI Score
			    {
				    aiscore += +1
				    backgrnd.AIScore.text = String(aiscore);
				    playerScoredTwo()
				    if (aiscore >9)
				    {
					    backgrnd.AIScore.width = 40;
				    }
			    }
			}
			
			if (ball.x > 100 && ball.x < 400)
			{
				hitHappens = false;
			}
			if (TwoBall == true)
			{
				if (ballTwo.x > 100 && ballTwo.x < 400)
			    {
				    hitHappensTwo = false;
			    }
			}
			
			//bounce from racket
			if (left_paddle.hitTestObject(ball) && hitHappens == false )
			{
				angleX = 360 - angle;
				angle = 180 + angleX;
				rads = angle * Math.PI  / 180;
				hitHappens = true;
				
				if (soundsOn == true)
				{
				    myChannel1 = mySound1.play(0,1);					
				}
				if (SpeedUp == true)
				{
					ball_speed = ball_speed - ball_speed_icrease;
				}
			}
			if (TwoBall == true)
			{
			    if (left_paddle.hitTestObject(ballTwo) && hitHappensTwo == false )
			    {
				    angleXTwo = 360 - angleTwo;
				    angleTwo = 180 + angleXTwo;
				    radsTwo = angleTwo * Math.PI  / 180;
				    hitHappensTwo = true;
				
				    if (soundsOn == true)
				    {
				        myChannel1 = mySound1.play(0,1);					
				    }
				    if (SpeedUp == true)
				    {
					    ball_speed = ball_speed - ball_speed_icrease;
				    }
			    }
			}
			if (right_paddle.hitTestObject(ball) && hitHappens == false )
			{
				angleX = 180 - angle;
				angle = 0 + angleX;
				rads = angle * Math.PI  / 180;
				hitHappens = true;
				
				if (soundsOn == true)
				{
				    myChannel1 = mySound1.play(0,1);					
				}
				if (SpeedUp == true)
				{
					ball_speed = ball_speed - ball_speed_icrease;
				}
			}
			if (TwoBall == true)
			{
			    if (right_paddle.hitTestObject(ballTwo) && hitHappensTwo == false )
			    {
				    angleXTwo = 180 - angleTwo;
				    angleTwo = 0 + angleXTwo;
				    radsTwo = angleTwo * Math.PI  / 180;
				    hitHappensTwo = true;
				
				    if (soundsOn == true)
				    {
				        myChannel1 = mySound1.play(0,1);					
				    }
				    if (SpeedUp == true)
				    {
					    ball_speed = ball_speed - ball_speed_icrease;
				    }				
			    }
			}
			//bounce from borders
			if (ball.y <= 0) //top
			{
				var angleX:Number; //insignificant name
				
				angleX = 360 - angle;
				angle = 0 + angleX;
				rads = angle * Math.PI  / 180;
			}
			if (ball.y >= backgrnd.height) //bottom
			{
				var angleY:Number;
				
				angleY = angle;
				angle = 0 - angleY;
				rads = angle * Math.PI  / 180;
			}
			if (TwoBall == true)
			{
			    if (ballTwo.y <= 0) //top
			    {
				    var angleXTwo:Number; //insignificant name
				
				    angleXTwo = 360 - angleTwo;
				    angleTwo = 0 + angleXTwo;
				    radsTwo = angleTwo * Math.PI  / 180;
			    }
			    if (ballTwo.y >= backgrnd.height) //bottom
			    {
				    var angleYTwo:Number;
				
				    angleYTwo = angleTwo;
				    angleTwo = 0 - angleYTwo;
				    radsTwo = angleTwo * Math.PI  / 180;
			    }
			}
			
			left_paddle.y += controlspeedP;
		    right_paddle.y += controlspeedA;
			
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
				controlspeedP = 0;
			}
			if(event.keyCode == Keyboard.S)
			{
				controlspeedP = 0;
			}
			if(event.keyCode == Keyboard.UP)
			{
				controlspeedA = 0;
			}
			if(event.keyCode == Keyboard.DOWN)
			{
				controlspeedA = 0;
			}
		}
		function onKeyPressDown(event:KeyboardEvent):void 
		{
			if(event.keyCode == Keyboard.W) //player moves up
			{
				controlspeedP = -paddle_speed;
				//left_paddle.y += -paddle_speed
			}
			if(event.keyCode == Keyboard.S) //player moves down
			{
				controlspeedP = paddle_speed;
				//left_paddle.y += +paddle_speed
			}
			if(event.keyCode == Keyboard.UP) //player moves up
			{
				controlspeedA = -paddle_speed;
				//right_paddle.y += -paddle_speed
			}
			if(event.keyCode == Keyboard.DOWN) //player moves down
			{
				controlspeedA = paddle_speed;
				//right_paddle.y += +paddle_speed
			}
			if(event.keyCode == Keyboard.ESCAPE)
			{			
			    if (InMenu == false)
				{
					removeEventListener(Event.ENTER_FRAME, frame);
				
				    menu();
					InMenu = true;
			    }
				else
				{
					removeChild(gameMenu)
				
				    addEventListener(Event.ENTER_FRAME, frame);
				    stage.focus = this;
					InMenu = false;
					
				    if (musicOn == true)
			        {
			            myChannel = mySound.play(lastPosition,9999);
			        }
				}
		    }
		}
		function aiScored():void //ball reset from AI to Player   //Quadrant 2 and 3 (BL & TL)
		{
			ball.x = 470;
			ball.y = 200;
			
			var num = Math.round(Math.random()* 1 + 0);
			if (num == 0)
			{
				angle = Math.round(Math.random()* 60 + 285);  //Q4 
			}
			else 
			{
				angle = Math.round(Math.random()* 60 + 15);  //Q1
			}
			
			rads = angle * Math.PI  / 180;
			
			if (SpeedUp == true)
			{
				ball_speed = -10
			}
		}
		function aiScoredTwo():void
		{
		    if (TwoBall == true)  //TwoBall
			{
			    ballTwo.x = 470;
			    ballTwo.y = 200;
			
			    var numTwo = Math.round(Math.random()* 1 + 0);
			    if (numTwo == 0)
			    {
				    angleTwo = Math.round(Math.random()* 60 + 285);  //Q4 
			    }
			    else 
			    {
				    angleTwo = Math.round(Math.random()* 60 + 15);  //Q1
			    }
			
			    radsTwo = angleTwo * Math.PI  / 180;
			 }
			 
			 if (SpeedUp == true)
			 {
				 ball_speed = -10
			 }
		}
		function playerScored():void //ball reset from Player to AI     //Q 1 & 4 (BR & TR)
		{
			ball.x = 80;
			ball.y = 200;
			
			var num = Math.round(Math.random()* 1 + 0);
			if (num == 0)
			{
				angle = Math.round(Math.random()* 60 + 195);  //Q3
			}
			else 
			{
				angle = Math.round(Math.random()* 60 + 105);  //Q2
			}
			
			rads = angle * Math.PI  / 180;
			
			if (SpeedUp == true)
			{
				ball_speed = -10
			}
		}
		function playerScoredTwo():void
		{
			if (TwoBall == true) //TwoBall
			{
			    ballTwo.x = 80;
			    ballTwo.y = 200;
			
			    var numTwo = Math.round(Math.random()* 1 + 0);
			    if (numTwo == 0)
			    {
				    angleTwo = Math.round(Math.random()* 60 + 195);  //Q3
			    }
			    else 
			    {
				    angleTwo = Math.round(Math.random()* 60 + 105);  //Q2
			    }
			
			    radsTwo = angleTwo * Math.PI  / 180;
				
				if (SpeedUp == true)
			    {
				    ball_speed = -10
			    }
			}
		}
	}	
}