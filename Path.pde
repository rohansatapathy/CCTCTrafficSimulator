public class Path {
  private Point[] nodes;
  private PApplet canvas;
  
  Path(Point[] nodes, PApplet canvas) {
    this.nodes = nodes;
    this.canvas = canvas;
  }
  
  void draw() {
    this.draw(color(0, 0, 0));
    
    
  }
  
  void draw(color c) {
    
    if (nodes.length >= 2) {
      color strokeColorOriginal = g.strokeColor;
      color fillColorOriginal = g.fillColor;
      
      canvas.stroke(c);
      
      canvas.beginShape();
      
      canvas.curveVertex(nodes[0].getX(), nodes[0].getY());
      for (int i = 0; i < nodes.length; i++) {
        canvas.curveVertex(nodes[i].getX(), nodes[i].getY());
        nodes[i].draw(c);
        canvas.noFill();
        
      }
      canvas.curveVertex(nodes[nodes.length - 1].getX(), nodes[nodes.length - 1].getY());
      canvas.endShape();
      
      canvas.stroke(strokeColorOriginal);
      canvas.fill(fillColorOriginal);
    }
    
  }
  
    
  
}
