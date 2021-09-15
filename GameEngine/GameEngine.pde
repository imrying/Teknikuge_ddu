Gameengine gameengine;

class Gameengine
{
  InputController inputController;
  CollisionController collisionController;
  GravityController gravityController;
  LevelGenerator levelGenerator;

  ArrayList<GameObject> gameObjects;
  int[] collisionArray;

  PVector[] gravitys;
  Boolean state = true;
  float pace = 5;


  Gameengine()
  {
    noStroke();
    inputController = new InputController();
    collisionController = new CollisionController();
    gravityController = new GravityController();

    gravitys = new PVector[2];
    gameObjects = new ArrayList<GameObject>();

    gameObjects.add(new Player(100, 100, 75, color(255, 0, 0)));
    gameObjects.add(new Player(100, height/2+100, 75, color(255, 0, 0)));


    levelGenerator = new LevelGenerator();




    gravitys[0] = new PVector(0, 0.5);
    gravitys[1] = new PVector(0, 0.5);

    collisionArray = new int[2];

    gameObjects.add(new Wall(700, 500, 250, 50, color(255, 255, 0)));
    gameObjects.add(new Wall(100, 300, 250, 50, color(255, 255, 0)));
    gameObjects.add(new Wall(900, 700, 250, 50, color(255, 255, 0)));
    gameObjects.add(new GameObject(width/2, height-10, width, 20, color(0, 0, 0)));
    gameObjects.add(new GameObject(width/2, height/2, width, 40, color(0, 0, 0)));
    gameObjects.add(new GameObject(width/2, 10, width, 20, color(0, 0, 0)));
    gameObjects.add(new GravityButton(800, 800, 50, 50, color(0, 255, 0), 5));
  }

  void head()
  {
    background(255);
    
    gameObjects.addAll(levelGenerator.update(pace));
    

    for (GameObject obj : gameObjects)
    {
      if (obj.id == 1) {
        if (state)
        {
          obj.update(inputController.getInputs(state, gravitys[0], gravitys[1]), pace, gravitys[0].x, gravitys[0].y, collisionArray[0]);
        } else
        {
          obj.update(inputController.getInputs(state, gravitys[0], gravitys[1]), pace, gravitys[1].x, gravitys[1].y, collisionArray[1]);
        }
        state = !state;
      } else
      {
        obj.update(inputController.getInputs(true, gravitys[0], gravitys[1]), pace, 0, 0);
      }
    }

    collisionArray = collisionController.collisionCheck(gameObjects, gameObjects.get(0), gameObjects.get(1), gravitys[0], gravitys[1]);

    if (collisionArray[2] != 0 || collisionArray[3] != 0)
    {
      gravitys = gravityController.changeGravity(collisionArray[2], collisionArray[3], gravitys[1], gravitys[0]);
      if (collisionArray[2] != 0)
      {
        gameObjects.get(1).vel = new PVector(0, 0);
      }
      if (collisionArray[3] != 0)
      {
        gameObjects.get(0).vel = new PVector(0, 0);
      }
    }

    if ((collisionArray[2] != 0) || (collisionArray[3] != 0))
    {
      gameObjects.remove(collisionController.gravityButton);
    }

    for (GameObject obj : gameObjects)
    {
      obj.render();
    }
  }
  
  

  void restartLevel()
  {
    //empty for now
  }
}

void setup()
{
  size(1920, 1080);
  gameengine = new Gameengine();
}

void draw()
{
  gameengine.head();
}
