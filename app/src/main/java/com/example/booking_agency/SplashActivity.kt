package com.example.booking_agency

import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.animation.AnimationUtils
import android.widget.ImageView
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity

class SplashActivity : AppCompatActivity() {

    companion object {
        private const val SPLASH_DURATION = 2500L // 2.5 seconds
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_splash)

        initializeAnimations()
        navigateToMainActivity()
    }

    private fun initializeAnimations() {
        // Find views
        val logoImage = findViewById<ImageView>(R.id.splash_logo)
        val appName = findViewById<TextView>(R.id.splash_app_name)
        val tagline = findViewById<TextView>(R.id.splash_tagline)

        // Load animations
        val fadeIn = AnimationUtils.loadAnimation(this, R.anim.fade_in)
        val slideUp = AnimationUtils.loadAnimation(this, R.anim.slide_up)

        // Set animation durations
        fadeIn.duration = 1000
        slideUp.duration = 800
        slideUp.startOffset = 300

        // Apply animations
        logoImage?.startAnimation(fadeIn)
        appName?.startAnimation(slideUp)
        tagline?.let {
            it.startAnimation(slideUp)
            it.animation?.startOffset = 500
        }
    }

    private fun navigateToMainActivity() {
        Handler(Looper.getMainLooper()).postDelayed({
            val intent = Intent(this@SplashActivity, MainActivity::class.java)
            startActivity(intent)
            
            // Add custom transition
            overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out)
            
            // Close splash activity
            finish()
        }, SPLASH_DURATION)
    }

    @Deprecated("Deprecated in Java")
    override fun onBackPressed() {
        // Disable back button on splash screen
        // Do nothing
    }
}
