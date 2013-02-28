final static double earth_radius = 6371; //km
MercatorMap map;
PImage map_background;

PVector me=null;
PVector me_pixel=null;
PVector me_last=null;
/**
 * Utility class to convert between geo-locations and Cartesian screen coordinates.
 * Can be used with a bounding box defining the map section.
 *
 * (c) 2011 Till Nagel, tillnagel.com
 */
public class MercatorMap {

  public static final float DEFAULT_TOP_LATITUDE = 80;
  public static final float DEFAULT_BOTTOM_LATITUDE = -80;
  public static final float DEFAULT_LEFT_LONGITUDE = -180;
  public static final float DEFAULT_RIGHT_LONGITUDE = 180;

  /** Horizontal dimension of this map, in pixels. */
  protected float mapScreenWidth;
  /** Vertical dimension of this map, in pixels. */
  protected float mapScreenHeight;

  /** Northern border of this map, in degrees. */
  protected float topLatitude;
  /** Southern border of this map, in degrees. */
  protected float bottomLatitude;
  /** Western border of this map, in degrees. */
  protected float leftLongitude;
  /** Eastern border of this map, in degrees. */
  protected float rightLongitude;

  private float topLatitudeRelative;
  private float bottomLatitudeRelative;
  private float leftLongitudeRadians;
  private float rightLongitudeRadians;

  public MercatorMap(float mapScreenWidth, float mapScreenHeight) {
    this(mapScreenWidth, mapScreenHeight, DEFAULT_TOP_LATITUDE, DEFAULT_BOTTOM_LATITUDE, DEFAULT_LEFT_LONGITUDE, DEFAULT_RIGHT_LONGITUDE);
  }

  /**
   * Creates a new MercatorMap with dimensions and bounding box to convert between geo-locations and screen coordinates.
   *
   * @param mapScreenWidth Horizontal dimension of this map, in pixels.
   * @param mapScreenHeight Vertical dimension of this map, in pixels.
   * @param topLatitude Northern border of this map, in degrees.
   * @param bottomLatitude Southern border of this map, in degrees.
   * @param leftLongitude Western border of this map, in degrees.
   * @param rightLongitude Eastern border of this map, in degrees.
   */
  public MercatorMap(float mapScreenWidth, float mapScreenHeight, float topLatitude, float bottomLatitude, float leftLongitude, float rightLongitude) {
    this.mapScreenWidth = mapScreenWidth;
    this.mapScreenHeight = mapScreenHeight;
    this.topLatitude = topLatitude;
    this.bottomLatitude = bottomLatitude;
    this.leftLongitude = leftLongitude;
    this.rightLongitude = rightLongitude;

    this.topLatitudeRelative = getScreenYRelative(topLatitude);
    this.bottomLatitudeRelative = getScreenYRelative(bottomLatitude);
    this.leftLongitudeRadians = getRadians(leftLongitude);
    this.rightLongitudeRadians = getRadians(rightLongitude);
  }

  /**
   * Projects the geo location to Cartesian coordinates, using the Mercator projection.
   *
   * @param geoLocation Geo location with (latitude, longitude) in degrees.
   * @returns The screen coordinates with (x, y).
   */
  public PVector getScreenLocation(PVector geoLocation) {
    float latitudeInDegrees = geoLocation.x;
    float longitudeInDegrees = geoLocation.y;

    return new PVector(getScreenX(longitudeInDegrees), getScreenY(latitudeInDegrees));
  }

  private float getScreenYRelative(float latitudeInDegrees) {
    return log(tan(latitudeInDegrees / 360f * PI + PI / 4));
  }

  protected float getScreenY(float latitudeInDegrees) {
    return mapScreenHeight * (getScreenYRelative(latitudeInDegrees) - topLatitudeRelative) / (bottomLatitudeRelative - topLatitudeRelative);
  }

  private float getRadians(float deg) {
    return deg * PI / 180;
  }

  protected float getScreenX(float longitudeInDegrees) {
    float longitudeInRadians = getRadians(longitudeInDegrees);
    return mapScreenWidth * (longitudeInRadians - leftLongitudeRadians) / (rightLongitudeRadians - leftLongitudeRadians);
  }
}
// based on haversine formula - http://en.wikipedia.org/wiki/Haversine_formula
float distance(PVector lat_lon_0, PVector lat_lon_1) {

  float lat0 = to_radians(lat_lon_0.x);
  float lon0 = to_radians(lat_lon_0.y);
  float lat1 = to_radians(lat_lon_1.x);
  float lon1 = to_radians(lat_lon_1.y);

  float dlat = lat1 - lat0;
  float dlon = lon1 - lon0;

  double h = sin(dlat / 2) * sin(dlat / 2) + cos(lon0) * cos(lon1) * sin(dlon / 2) * sin(dlon / 2);
  double a = 2 * Math.atan2(Math.sqrt(h), Math.sqrt(1 - h));
  double d = h * earth_radius * 1000.0;

  return  (float)d;
}

float angle(PVector a, PVector b) {
  // a . b = |a||b|cos(ø)
  float angle = acos(a.dot(b) / (a.mag() * b.mag()));
  if (b.y > a.y)
    angle = TWO_PI - angle;
  return angle;
}

float ellipsoid_a = 6378137.0;
float ellipsoid_b = 6356752.314;

float distance_world_mercator(PVector lat_lon_0, PVector lat_lon_1) {

  float lat0 = to_radians(lat_lon_0.x);
  float lon0 = to_radians(lat_lon_0.y);
  float lat1 = to_radians(lat_lon_1.x);
  float lon1 = to_radians(lat_lon_1.y);

  PVector m0 = new PVector();
  m0.y = ellipsoid_a * lon0;
  m0.x = ellipsoid_a * log((sin(lat0) + 1) / cos(lat0));

  PVector m1 = new PVector();
  m1.y = ellipsoid_a * lon1;
  m1.x = ellipsoid_a * log((sin(lat1) + 1) / cos(lat1));

  return PVector.dist(m1, m0);
}

float to_radians(float deg) {
  return deg * PI / 180;
}

class Coord
{
  float lat;
  float lon;
  Coord(float la, float lo)
  {
    lat=la;
    lon=lo;
  }
}
class Path {
  private Coord[] coordA;
  private boolean al;
  private ArrayList<Coord> coordAL;
  public Path()
  {
    al=true;
    coordAL=new ArrayList<Coord>();
  }
  public Path(int dim)
  {
    al=false;
    coordA=new Coord[dim];
  }
  public Coord getElem(int i)
  {
    if (al)
    {
      return coordAL.get(i);
    }
    else
    {
      return coordA[i];
    }
  }
  public boolean setElem(int i, Coord c)
  {
    try {
      if (al)
      {
        coordAL.add(i, c);
      }
      else
      {
        coordA[i]=c;
      }
      return true;
    }
    catch(Exception e)
    {
      return false;
    }
  }
  public int size()
  {
    if (al)
      {
        return coordAL.size();
      }
      else
      {
        return coordA.length;
      }
  }
}

