# app/utils.py
from reportlab.lib.pagesizes import A4
from reportlab.pdfgen import canvas
import textwrap
import datetime
import numpy as np
from PIL import Image
import io

# ---- IMAGE PREPROCESS -----
def preprocess_image(image_bytes):
    image = Image.open(io.BytesIO(image_bytes)).convert('RGB')
    image = image.resize((224,224))
    img = np.array(image) / 255.0
    img = np.expand_dims(img, axis=0)
    return img

# ---- TEXT WRAP UTILITY -----
def draw_multiline(c, text, x, y, max_chars=95, height=14):
    lines = textwrap.wrap(text, max_chars)
    for line in lines:
        c.drawString(x, y, line)
        y -= height
    return y - 10

# ---- AI PDF REPORT GENERATOR -----
# app/utils.py (Only replace the PDF function)

from reportlab.lib.pagesizes import A4
from reportlab.lib import colors
from reportlab.lib.styles import ParagraphStyle
from reportlab.lib.units import inch
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, Flowable
from reportlab.pdfgen.canvas import Canvas
from reportlab.lib.utils import ImageReader
import datetime


class HeaderBanner(Flowable):
    """Custom header banner with gradient + title + date"""
    def __init__(self, title, report_id):
        super().__init__()
        self.width = A4[0]
        self.height = 70
        self.title = title
        self.report_id = report_id

    def draw(self):
        c: Canvas = self.canv

        # Gradient Background
        c.saveState()
        for i in range(100):
            color = colors.Color(0/255, (70+i*1.2)/255, (160+i)/255, alpha=1)
            c.setFillColor(color)
            c.rect(0, self.height - (i*(self.height/100)), self.width, self.height/100, fill=1, stroke=0)
        c.restoreState()

        # Title
        c.setFillColor(colors.white)
        c.setFont("Helvetica-Bold", 22)
        c.drawString(40, 40, self.title)

        # Report ID + Date
        c.setFont("Helvetica", 10)
        now = datetime.datetime.now().strftime("%d %b %Y, %H:%M")
        c.drawRightString(self.width - 40, 50, f"Report ID: {self.report_id}")
        c.drawRightString(self.width - 40, 35, f"Generated: {now}")


def generate_pdf_report(path, name, age, disease, confidence, explanation):
    doc = SimpleDocTemplate(
        path,
        pagesize=A4,
        rightMargin=0,
        leftMargin=0,
        topMargin=40,  # Space for banner
        bottomMargin=40,
    )

    elements = []

    # ---------------------------
    # Insert Header Banner
    # ---------------------------
    report_id = f"NRAI-{datetime.datetime.now().strftime('%Y%m%d%H%M%S')}"
    elements.append(HeaderBanner("NeuroAI MRI Analysis Report", report_id))
    elements.append(Spacer(1, 20))

    # ---------------------------
    # Patient Information Table
    # ---------------------------
    table_data = [
        ["Patient Name", name],
        ["Age", str(age)],
        ["Diagnosis", disease.capitalize()],
        ["Confidence", f"{confidence:.2f}%"],
    ]

    table = Table(table_data, colWidths=[130, 320])
    table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (1, 0), colors.HexColor("#DCE4F7")),
        ('TEXTCOLOR', (0, 0), (1, 0), colors.black),
        ('FONTNAME', (0, 0), (-1, -1), 'Helvetica'),
        ('FONTSIZE', (0, 0), (-1, -1), 12),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 10),
        ('BACKGROUND', (0, 1), (-1, -1), colors.HexColor("#F7F9FC")),
        ('GRID', (0, 0), (-1, -1), 0.6, colors.grey),
    ]))

    elements.append(table)
    elements.append(Spacer(1, 25))

    # ---------------------------
    # Section Header
    # ---------------------------
    header_style = ParagraphStyle(
        name="HeaderStyle",
        fontSize=16,
        leading=20,
        textColor=colors.HexColor("#1C3FAA"),
        spaceAfter=12,
    )

    elements.append(Paragraph("<b>AI Interpretation</b>", header_style))

    # ---------------------------
    # Explanation
    # ---------------------------
    body_style = ParagraphStyle(
        name="BodyStyle",
        fontSize=12,
        leading=18,
        textColor=colors.black,
        alignment=4,  # Justified
    )

    elements.append(Paragraph(explanation.replace("\n", "<br/>"), body_style))
    elements.append(Spacer(1, 25))

    # ---------------------------
    # Disclaimer
    # ---------------------------
    disclaimer_style = ParagraphStyle(
        name="Disclaimer",
        fontSize=10,
        leading=14,
        textColor=colors.red,
        alignment=1,  # center
    )

    disclaimer = """
    <b>Disclaimer:</b> This report is AI-generated and intended for informational purposes only.
    It is not a medical diagnosis. Always consult a certified medical professional.
    """

    elements.append(Paragraph(disclaimer, disclaimer_style))
    elements.append(Spacer(1, 12))

    # Build PDF
    doc.build(elements)
