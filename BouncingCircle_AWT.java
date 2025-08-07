import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class BouncingCircle extends JPanel implements ActionListener {
    private int x = 50;     // Circle's X position
    private int y = 50;     // Circle's Y position
    private int radius = 30;
    private int dx = 3;     // Change in X
    private int dy = 3;     // Change in Y

    private Timer timer;

    public BouncingCircle() {
        setPreferredSize(new Dimension(400, 300));
        setBackground(Color.WHITE);
        timer = new Timer(100, this);
        timer.start();
    }

    @Override
    protected void paintComponent(Graphics g) {
        super.paintComponent(g);
        g.setColor(Color.RED);
        g.fillOval(x, y, radius * 2, radius * 2);
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        // Bounce off the left or right walls
        if (x + dx < 0 || x + 2 * radius + dx > getWidth()) {
            dx = -dx;
        }
        // Bounce off the top or bottom walls
        if (y + dy < 0 || y + 2 * radius + dy > getHeight()) {
            dy = -dy;
        }

        x += dx;
        y += dy;
        repaint();  // Trigger paintComponent
    }

    public static void main(String[] args) {
        JFrame frame = new JFrame("Moving Circle Simulation");
        BouncingCircle animationPanel = new BouncingCircle();

        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.add(animationPanel);
        frame.pack();
        frame.setLocationRelativeTo(null); // Center on screen
        frame.setVisible(true);
    }
}
