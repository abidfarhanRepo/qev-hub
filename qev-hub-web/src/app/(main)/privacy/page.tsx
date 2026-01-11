export default function PrivacyPage() {
  return (
    <div className="min-h-screen bg-background relative overflow-hidden">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-16 relative z-10">
        <div className="mb-12">
          <h1 className="text-4xl font-black uppercase tracking-widest text-foreground mb-4">
            Privacy <span className="text-primary">Policy</span>
          </h1>
          <p className="text-muted-foreground text-lg">
            Last updated: January 12, 2026
          </p>
        </div>

        <div className="prose prose-invert max-w-none space-y-8">
          <section>
            <h2 className="text-2xl font-bold text-foreground mb-4">1. Information We Collect</h2>
            <div className="space-y-4 text-muted-foreground">
              <p>QEV-Hub collects information you provide directly to us, including:</p>
              <ul className="list-disc pl-6 space-y-2">
                <li>Account information (name, email address, phone number)</li>
                <li>Order and purchase history</li>
                <li>Shipping and billing addresses</li>
                <li>Payment information (processed securely through third-party payment processors)</li>
                <li>Vehicle preferences and browsing history</li>
              </ul>
            </div>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-foreground mb-4">2. How We Use Your Information</h2>
            <div className="space-y-4 text-muted-foreground">
              <p>We use the information we collect to:</p>
              <ul className="list-disc pl-6 space-y-2">
                <li>Process and fulfill your orders</li>
                <li>Provide customer support</li>
                <li>Send you transactional communications (order confirmations, shipping updates)</li>
                <li>Improve our services and user experience</li>
                <li>Comply with legal obligations</li>
              </ul>
            </div>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-foreground mb-4">3. Information Sharing</h2>
            <div className="space-y-4 text-muted-foreground">
              <p>We may share your information with:</p>
              <ul className="list-disc pl-6 space-y-2">
                <li>EV manufacturers for order fulfillment and delivery</li>
                <li>Shipping and logistics providers</li>
                <li>Payment processors</li>
                <li>Service providers who assist in operating our platform</li>
              </ul>
              <p className="mt-4">We do not sell your personal information to third parties.</p>
            </div>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-foreground mb-4">4. Data Security</h2>
            <div className="space-y-4 text-muted-foreground">
              <p>We implement appropriate technical and organizational measures to protect your personal data against unauthorized access, alteration, disclosure, or destruction.</p>
              <p>Our payment processing is PCI-DSS compliant, and we use encryption to protect sensitive data in transit.</p>
            </div>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-foreground mb-4">5. Your Rights</h2>
            <div className="space-y-4 text-muted-foreground">
              <p>Under Qatar's data protection laws, you have the right to:</p>
              <ul className="list-disc pl-6 space-y-2">
                <li>Access your personal data</li>
                <li>Request correction of inaccurate data</li>
                <li>Request deletion of your personal data</li>
                <li>Object to processing of your data</li>
                <li>Request data portability</li>
              </ul>
            </div>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-foreground mb-4">6. Cookies</h2>
            <div className="space-y-4 text-muted-foreground">
              <p>We use cookies and similar technologies to:</p>
              <ul className="list-disc pl-6 space-y-2">
                <li>Remember your preferences and settings</li>
                <li>Analyze website traffic and usage patterns</li>
                <li>Provide personalized content</li>
              </ul>
              <p className="mt-4">You can control cookie settings through your browser preferences.</p>
            </div>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-foreground mb-4">7. Contact Us</h2>
            <div className="space-y-4 text-muted-foreground">
              <p>If you have questions about this Privacy Policy or your personal data, please contact us at:</p>
              <p className="font-semibold text-foreground">privacy@qev-hub.qa</p>
            </div>
          </section>
        </div>
      </div>
    </div>
  )
}
