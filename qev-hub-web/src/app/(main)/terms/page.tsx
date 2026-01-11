export default function TermsPage() {
  return (
    <div className="min-h-screen bg-background relative overflow-hidden">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-16 relative z-10">
        <div className="mb-12">
          <h1 className="text-4xl font-black uppercase tracking-widest text-foreground mb-4">
            Terms of <span className="text-primary">Service</span>
          </h1>
          <p className="text-muted-foreground text-lg">
            Last updated: January 12, 2026
          </p>
        </div>

        <div className="prose prose-invert max-w-none space-y-8">
          <section>
            <h2 className="text-2xl font-bold text-foreground mb-4">1. Acceptance of Terms</h2>
            <div className="space-y-4 text-muted-foreground">
              <p>By accessing or using QEV-Hub, you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use our platform.</p>
              <p>QEV-Hub reserves the right to modify these terms at any time. Continued use of the platform after changes constitutes acceptance of the updated terms.</p>
            </div>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-foreground mb-4">2. Account Registration</h2>
            <div className="space-y-4 text-muted-foreground">
              <p>To use certain features of QEV-Hub, you must register for an account. You agree to:</p>
              <ul className="list-disc pl-6 space-y-2">
                <li>Provide accurate, current, and complete information</li>
                <li>Maintain the security of your account and password</li>
                <li>Accept responsibility for all activities under your account</li>
                <li>Notify us immediately of any unauthorized use</li>
              </ul>
              <p className="mt-4">You must be at least 18 years old to create an account and purchase vehicles.</p>
            </div>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-foreground mb-4">3. Vehicle Purchases</h2>
            <div className="space-y-4 text-muted-foreground">
              <h3 className="text-lg font-semibold text-foreground mt-6 mb-2">3.1 Orders</h3>
              <p>All vehicle orders are subject to availability and confirmation. We reserve the right to cancel orders due to inventory limitations, pricing errors, or other reasons.</p>

              <h3 className="text-lg font-semibold text-foreground mt-6 mb-2">3.2 Pricing</h3>
              <p>All prices are listed in Qatari Riyals (QAR) and include applicable taxes unless otherwise stated. Prices are subject to change without notice.</p>

              <h3 className="text-lg font-semibold text-foreground mt-6 mb-2">3.3 Payment</h3>
              <p>Payment is due at the time of order placement. We accept major credit cards, debit cards, and other payment methods as indicated on our platform.</p>

              <h3 className="text-lg font-semibold text-foreground mt-6 mb-2">3.4 Shipping and Delivery</h3>
              <p>Shipping times are estimates and may vary based on manufacturer availability, customs processing, and other factors. We are not liable for delays beyond our control.</p>
            </div>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-foreground mb-4">4. Returns and Refunds</h2>
            <div className="space-y-4 text-muted-foreground">
              <p>Due to the nature of vehicle sales, all vehicle purchases are final. Refunds or exchanges are only available in cases of:</p>
              <ul className="list-disc pl-6 space-y-2">
                <li>Manufacturing defects covered by warranty</li>
                <li>Misrepresentation of vehicle specifications</li>
                <li>Damage during shipping</li>
              </ul>
              <p className="mt-4">Please refer to individual manufacturer warranties for specific coverage details.</p>
            </div>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-foreground mb-4">5. User Conduct</h2>
            <div className="space-y-4 text-muted-foreground">
              <p>You agree not to:</p>
              <ul className="list-disc pl-6 space-y-2">
                <li>Use the platform for any illegal purpose</li>
                <li>Violate any applicable laws or regulations</li>
                <li>Transmit viruses or other harmful code</li>
                <li>Attempt to gain unauthorized access to our systems</li>
                <li>Impersonate any person or entity</li>
                <li>Interfere with other users' use of the platform</li>
              </ul>
            </div>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-foreground mb-4">6. Intellectual Property</h2>
            <div className="space-y-4 text-muted-foreground">
              <p>All content on QEV-Hub, including text, graphics, logos, images, and software, is owned by QEV-Hub or its licensors and is protected by copyright and other intellectual property laws.</p>
              <p>You may not reproduce, modify, distribute, or create derivative works of any content without our express written permission.</p>
            </div>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-foreground mb-4">7. Limitation of Liability</h2>
            <div className="space-y-4 text-muted-foreground">
              <p>QEV-Hub shall not be liable for any indirect, incidental, special, consequential, or punitive damages arising out of your use of the platform, including but not limited to loss of profits, data, or business opportunities.</p>
              <p>Our total liability to you for any claim shall not exceed the amount you paid to us for the specific service giving rise to the claim.</p>
            </div>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-foreground mb-4">8. Indemnification</h2>
            <div className="space-y-4 text-muted-foreground">
              <p>You agree to indemnify and hold harmless QEV-Hub, its officers, directors, employees, and agents from any claims, damages, or expenses arising from your use of the platform or violation of these terms.</p>
            </div>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-foreground mb-4">9. Dispute Resolution</h2>
            <div className="space-y-4 text-muted-foreground">
              <p>Any disputes arising from these terms shall be governed by the laws of the State of Qatar. Any legal action shall be brought in the courts of Qatar.</p>
            </div>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-foreground mb-4">10. Contact Information</h2>
            <div className="space-y-4 text-muted-foreground">
              <p>For questions about these Terms of Service, please contact us at:</p>
              <p className="font-semibold text-foreground">legal@qev-hub.qa</p>
            </div>
          </section>
        </div>
      </div>
    </div>
  )
}
