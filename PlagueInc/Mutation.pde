class Mutation{
  String name;
  int cost;
  int infIncrement;
  int sevIncrement;
  int letIncrement;
  ArrayList<String> prereqs;
  String type;
  boolean bought;
  boolean isBase;
  
  Mutation(String name, int cost, int infIncrement, int sevIncrement, int letIncrement, ArrayList<String> prereqs, String typeOfMutation, boolean isBaseMutation){
    this.name = name;
    this.cost = cost;
    this.infIncrement = infIncrement;
    this.sevIncrement = sevIncrement;
    this.letIncrement = letIncrement;
    this.prereqs = prereqs;
    //type refers to whether this mutation is a "tMutation" or a "sMutation"
    type = typeOfMutation;
    bought = false;
    isBase = isBaseMutation;
  }
  
  String name(){
    return name;
  }
  
  int cost(){
    return cost;
  }
  
  int infIncrement(){
    return infIncrement;
  }
  
  int sevIncrement(){
    return sevIncrement;
  }
  
  int letIncrement(){
    return letIncrement;
  }
  
  ArrayList<String> prereqs(){
    return prereqs;
  }
  
  boolean bought(){
    return bought;
  }
  
  boolean isBase(){
    return isBase;
  }
}
