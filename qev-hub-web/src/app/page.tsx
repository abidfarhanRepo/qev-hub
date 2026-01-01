export default function Home() {
  return (
    <div className="min-h-screen">
      {/* Hero Section */}
      <section className="bg-gradient-to-r from-primary to-secondary text-white py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center">
            <h1 className="text-5xl font-bold mb-6">
              Welcome to QEV Hub
            </h1>
            <p className="text-xl mb-8 max-w-2xl mx-auto">
              Qatar's premier electric vehicle marketplace and charging network
            </p>
            <div className="flex justify-center gap-4">
              <a
                href="/marketplace"
                className="bg-white text-primary px-8 py-3 rounded-lg font-medium hover:bg-gray-100 transition"
              >
                Browse Vehicles
              </a>
              <a
                href="/charging"
                className="bg-transparent border-2 border-white text-white px-8 py-3 rounded-lg font-medium hover:bg-white hover:text-primary transition"
              >
                Find Charging
              </a>
            </div>
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section className="py-16 bg-gray-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <h2 className="text-3xl font-bold text-center mb-12">Why Choose QEV Hub?</h2>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            <div className="bg-white p-6 rounded-lg shadow-md">
              <div className="text-4xl mb-4">🚗</div>
              <h3 className="text-xl font-bold mb-2">Direct from Manufacturers</h3>
              <p className="text-gray-600">
                Save 30-40% by purchasing directly from EV manufacturers
              </p>
            </div>
            <div className="bg-white p-6 rounded-lg shadow-md">
              <div className="text-4xl mb-4">⚡</div>
              <h3 className="text-xl font-bold mb-2">Charging Network</h3>
              <p className="text-gray-600">
                Access to Qatar's comprehensive EV charging station network
              </p>
            </div>
            <div className="bg-white p-6 rounded-lg shadow-md">
              <div className="text-4xl mb-4">📱</div>
              <h3 className="text-xl font-bold mb-2">Track Everything</h3>
              <p className="text-gray-600">
                Real-time order tracking and charging session management
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-16">
        <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h2 className="text-3xl font-bold mb-6">Ready to Go Electric?</h2>
          <p className="text-gray-600 mb-8">
            Join thousands of Qatar residents who have made the switch to electric vehicles
          </p>
          <a
            href="/signup"
            className="bg-primary text-white px-8 py-3 rounded-lg font-medium hover:bg-primary-dark transition inline-block"
          >
            Get Started Today
          </a>
        </div>
      </section>
    </div>
  )
}
