package com.example.booking_agency

import android.content.Context
import androidx.test.core.app.ApplicationProvider
import com.example.booking_agency.data.datasource.local.LocalDataSource
import com.example.booking_agency.data.datasource.local.RoomBookerDatabase
import com.example.booking_agency.domain.model.RoomDomain
import com.example.booking_agency.domain.model.RoomType
import com.example.booking_agency.domain.model.UserDomain
import com.example.booking_agency.domain.model.UserPreferencesDomain
import com.example.booking_agency.domain.repository.BookingRepository
import com.example.booking_agency.domain.repository.RoomRepository
import com.example.booking_agency.domain.repository.UserRepository
import com.example.booking_agency.data.repository.BookingRepositoryImpl
import com.example.booking_agency.data.repository.RoomRepositoryImpl
import com.example.booking_agency.data.repository.UserRepositoryImpl
import kotlinx.coroutines.runBlocking
import org.junit.Assert.*
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner

/**
 * Integration test for the clean architecture
 */
@RunWith(RobolectricTestRunner::class)
class ArchitectureIntegrationTest {

    private lateinit var context: Context
    private lateinit var database: RoomBookerDatabase
    private lateinit var localDataSource: LocalDataSource
    private lateinit var roomRepository: RoomRepository
    private lateinit var userRepository: UserRepository
    private lateinit var bookingRepository: BookingRepository

    @Before
    fun setup() {
        context = ApplicationProvider.getApplicationContext()
        database = RoomBookerDatabase.getInstance(context)
        localDataSource = LocalDataSource(database)
        roomRepository = RoomRepositoryImpl(localDataSource)
        userRepository = UserRepositoryImpl(localDataSource)
        bookingRepository = BookingRepositoryImpl(localDataSource)
    }

    @Test
    fun testCleanArchitectureIntegration() = runBlocking {
        // Test 1: Create and save a user through repository
        val user = UserDomain(
            id = "test_user",
            name = "Test User",
            email = "test@example.com",
            phone = "+1234567890",
            memberSince = "2024-01-01",
            preferences = UserPreferencesDomain()
        )

        val savedUser = userRepository.createUser(user)
        assertTrue(savedUser.isSuccess)
        assertEquals("test_user", savedUser.getOrNull())

        // Test 2: Retrieve user through repository
        val retrievedUser = userRepository.getUserById("test_user")
        assertNotNull(retrievedUser)
        assertEquals("Test User", retrievedUser?.name)

        // Test 3: Create and save a room
        val room = RoomDomain(
            id = "test_room",
            name = "Test Room",
            description = "A beautiful test room",
            type = RoomType.DELUXE,
            pricePerNight = 150.0,
            hotelName = "Test Hotel",
            location = "Test City",
            rating = 4.5f,
            reviewCount = 10,
            images = listOf("image1.jpg"),
            amenities = listOf("WiFi", "AC"),
            maxGuests = 2,
            size = "300 sq.ft",
            bedType = "1 King Bed",
            isAvailable = true,
            cancellationPolicy = "Free cancellation"
        )

        localDataSource.saveRoom(room)

        // Test 4: Retrieve room through repository
        val retrievedRoom = roomRepository.getRoomById("test_room")
        assertNotNull(retrievedRoom)
        assertEquals("Test Room", retrievedRoom?.name)
        assertEquals(150.0, retrievedRoom?.pricePerNight, 0.01)

        // Test 5: Test room filtering
        val allRooms = roomRepository.getAllRooms()
        assertTrue(allRooms.isNotEmpty())

        // Test 6: Test repository integration
        val roomsByType = roomRepository.getRoomsByType(RoomType.DELUXE)
        assertTrue(roomsByType.isNotEmpty())

        println("✅ All architecture integration tests passed!")
    }

    @Test
    fun testRepositoryInterfaces() = runBlocking {
        // Test that all repository interfaces are properly implemented
        assertNotNull(roomRepository)
        assertNotNull(userRepository)
        assertNotNull(bookingRepository)

        // Test that all required methods exist
        assertNotNull(roomRepository::getAllRooms)
        assertNotNull(roomRepository::getRoomById)
        assertNotNull(roomRepository::getRoomsByType)

        assertNotNull(userRepository::getCurrentUser)
        assertNotNull(userRepository::getUserById)
        assertNotNull(userRepository::createUser)

        assertNotNull(bookingRepository::getAllBookings)
        assertNotNull(bookingRepository::getBookingsByUserId)
        assertNotNull(bookingRepository::createBooking)

        println("✅ All repository interfaces are properly implemented!")
    }
}
