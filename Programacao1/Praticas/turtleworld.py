import unittest

import TurtleWorld

class Tests(unittest.TestCase):

    def test_turtle_world(self):
        tw = TurtleWorld.TurtleWorld(interactive=True)
        tw.setup_run()
        tw.delay = 0.01
        control = tw.make_turtle()
        control.set_color('magenta')
        control.move_turtle(-1)
        tw.clear()
        tw.quit()
        
    def test_turtle(self):
        tw = TurtleWorld.TurtleWorld()
        t = TurtleWorld.Turtle()
        t.delay = 0.01
        t.step()

        t.bk(10)
        t.rt(10)
        t.lt(-10)
        t.pu()
        t.pd()
        t.set_color('papaya whip')
        t.set_pen_color('yellow')

        TurtleWorld.fd(t, 10)
        TurtleWorld.bk(t, 10)
        TurtleWorld.lt(t, 10)
        TurtleWorld.rt(t, 10)
        TurtleWorld.pu(t)
        TurtleWorld.pd(t)
        TurtleWorld.set_color(t, 'cyan')
        TurtleWorld.set_pen_color(t, 'magenta')

        x = t.get_x()
        self.assertAlmostEquals(x, -9.0)

        y = t.get_y()
        self.assertAlmostEquals(y, 0.0)

        heading = t.get_heading()
        self.assertAlmostEquals(heading, -20)

        tw.quit()

if __name__ == '__main__':
    unittest.main()