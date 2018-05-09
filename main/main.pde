ArrayList<Block> onscreenItems;
Block person;


void setup() {
    size(1000, 500);
    background(240);
    person = new Block(800, 0);
//    person.movable = true;
}

void draw() {
  
  
  
  for(Block item : onscreenItems)
    item.show();
}
