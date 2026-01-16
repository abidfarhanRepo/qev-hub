from PIL import Image, ImageDraw
import math

def create_icon():
    # Dimensions
    size = 1024
    center = size // 2
    
    # Colors
    bg_color = (15, 23, 42)    # #0F172A
    fg_color = (0, 208, 132)   # #00D084
    
    # Create image
    im = Image.new('RGB', (size, size), bg_color)
    draw = ImageDraw.Draw(im)
    
    # Draw Q Body (Circle)
    # We want a thick ring
    margin = 200
    thickness = 100
    bbox = [(margin, margin), (size - margin, size - margin)]
    
    # We will draw a filled circle and then a smaller filled circle of bg_color inside
    draw.ellipse(bbox, fill=fg_color)
    
    inner_bbox = [(margin + thickness, margin + thickness), 
                  (size - margin - thickness, size - margin - thickness)]
    draw.ellipse(inner_bbox, fill=bg_color)
    
    # Draw Lightning Bolt Tail
    # The tail should come from the bottom right of the ring
    
    # Coordinates for a stylized bolt
    # It should look like it's emerging from the ring at around 45 degrees (bottom-right)
    # and striking downwards/outwards
    
    # Let's define a polygon
    # Start inside the ring
    p1 = (650, 650)  # Inside ring area roughly
    p2 = (850, 650)  # Out to right
    p3 = (750, 750)  # Back in a bit
    p4 = (900, 900)  # Tip of tail
    p5 = (700, 800)  # Back
    p6 = (600, 850)  # Left
    
    # Let's try a simpler bolt shape that forms the Q tail
    # A standard Q tail is a line 
    # Let's make it a sharp bolt
    
    bolt_points = [
        (600, 600), # Top Left of bolt (inside ring)
        (750, 600), # Top Right
        (700, 700), # Mid Right
        (850, 850), # Bottom Tip
        (650, 750), # Mid Bottom
        (550, 800), # Bottom Left
    ]
    
    # Let's refine the bolt to look more integrated
    # We want it to cross the ring
    
    # Ring extends from 200 to 824 (since 1024-200)
    # Middle of ring strip is around 762 radius
    
    # Let's draw a polygon that cuts through
    # Tip at 850, 850 (outside)
    # Root at 600, 600 (inside hole)
    
    bolt = [
        (630, 630), # Start inside top-left of tail
        (780, 630),
        (720, 720),
        (880, 880), # Tip
        (680, 780),
        (580, 850)
    ]
    
    # Better shape:
    #      /
    #    /
    #  /
    #      /
    #    /
    
    # Let's try 3 points "Z" style but rotated?
    # Or just a sharp wedge.
    
    bolt_wedge = [
        (650, 650),
        (800, 680),
        (850, 850), # Tip
        (680, 800),
    ]
    
    draw.polygon(bolt_wedge, fill=fg_color)
    
    # Now verify "cleaning" the intersection if needed?
    # No, simple overlay is fine for a flat icon.
    
    # Let's add a small circle in the center to make it techy?
    # No, keep it minimal.
    
    # Save
    output_path = '/home/pi/Desktop/QEV/qev-hub-mobile/assets/icon/app_icon.png'
    im.save(output_path)
    print(f"Icon saved to {output_path}")

if __name__ == "__main__":
    create_icon()
