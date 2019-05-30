package components;

public class RenderComponent {

    private String name;
    private Shape shape;
    private short xcoord;
    private short ycoord;
    private short width;
    private short height;
    private short color;


    public RenderComponent(String name, Shape shape,
                    short xcoord, short ycoord, short width, short height, short color){
        this.shape = shape;
        this.name = name;
        this.xcoord = xcoord;
        this.ycoord = ycoord;
        this.width = width;
        this.height = height;
        this.color = color;
    }

    public String getName(){
        return name;
    }

    public Shape getShape() {
        return shape;
    }

    public Short getXcoord() {
        return xcoord;
    }

    public void setXcoord(Short xcoord) {
        this.xcoord = xcoord;
    }

    public Short getYcoord() {
        return ycoord;
    }

    public void setYcoord(Short ycoord) {
        this.ycoord = ycoord;
    }

    public Short getWidth() {
        return width;
    }

    public void setWidth(Short width) {
        this.width = width;
    }

    public Short getHeight() {
        return height;
    }

    public void setHeight(Short height) {
        this.height = height;
    }

    public Short getColor() {
        return color;
    }

    public void setColor(Short color) {
        this.color = color;
    }
}
