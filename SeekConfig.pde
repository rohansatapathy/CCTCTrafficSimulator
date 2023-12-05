class SeekConfig {
  public final float SEEK_DISTANCE_PED;
  public final float SEEK_DISTANCE_CAR;
  public final float SEEK_DISTANCE_BUS;
  
  public final float SEEK_RADIUS_PED;
  public final float SEEK_RADIUS_CAR;
  public final float SEEK_RADIUS_BUS;
  
  public final float SPAWN_BUFFER;
  
  SeekConfig(float seekDistancePed, float seekRadiusPed, float seekDistanceCar, float seekRadiusCar, float seekDistanceBus, float seekRadiusBus, float spawnBuffer) {
    this.SEEK_DISTANCE_PED = seekDistancePed;
    this.SEEK_DISTANCE_CAR = seekDistanceCar;
    this.SEEK_DISTANCE_BUS = seekDistanceBus;
    this.SEEK_RADIUS_PED = seekRadiusPed;
    this.SEEK_RADIUS_CAR = seekRadiusCar;
    this.SEEK_RADIUS_BUS = seekRadiusBus;
    this.SPAWN_BUFFER = spawnBuffer;
  }
  
  float getSeekDistance(Commuter commuter) {
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
  
  float getSeekRadius(Commuter commuter) {
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
  
  float getSpawnBuffer() {
    return this.SPAWN_BUFFER;
  }
}
