class Mutation{
  String name;
  int cost;
  int infIncrement;
  int sevIncrement;
  int letIncrement;
  ArrayList<String> prereqs;
  
  Mutation(String name, int cost, int infIncrement, int sevIncrement, int letIncrement, ArrayList<String> prereqs){
    this.name = name;
    this.cost = cost;
    this.infIncrement = infIncrement;
    this.sevIncrement = sevIncrement;
    this.letIncrement = letIncrement;
    this.prereqs = prereqs;
  }
}
