class AdditionalInformationRepository{
  double mass;

  AdditionalInformationRepository({
    required this.mass,
  });

  double getMass(){
    return mass;
  }

  void setMass(double mass){
    this.mass = mass;
  }
}