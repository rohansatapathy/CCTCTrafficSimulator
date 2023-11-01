public class SeekConfig {
  public final int SEEK_DISTANCE_PED;
  public final int SEEK_DISTANCE_CAR;
  public final int SEEK_DISTANCE_BUS;
  
  public final int SEEK_RADIUS_PED;
  public final int SEEK_RADIUS_CAR;
  public final int SEEK_RADIUS_BUS;
  
  SeekConfig(int seekDistancePed, int seekRadiusPed, int seekDistanceCar, int seekRadiusCar, int seekDistanceBus, int seekRadiusBus) {
    this.SEEK_DISTANCE_PED = seekDistancePed;
    this.SEEK_DISTANCE_CAR = seekDistanceCar;
    this.SEEK_DISTANCE_BUS = seekDistanceBus;
    this.SEEK_RADIUS_PED = seekRadiusPed;
    this.SEEK_RADIUS_CAR = seekRadiusCar;
    this.SEEK_RADIUS_BUS = seekRadiusBus;
  }
  
  int getSeekDistance(Commuter commuter) {
    if (commuter instanceof Car) {
      return this.SEEK_DISTANCE_CAR;
    }
    else if (commuter instanceof Bus) {
      return this.SEEK_DISTANCE_BUS;
    }
    else {
      return this.SEEK_DISTANCE_PED;
    }
  }
  
  int getSeekRadius(Commuter commuter) {
    if (commuter instanceof Car) {
      return this.SEEK_RADIUS_CAR;
    }
    else if (commuter instanceof Bus) {
      return this.SEEK_RADIUS_BUS;
    }
    else {
      return this.SEEK_RADIUS_PED;
    }
  }
}
