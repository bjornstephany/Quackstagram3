package src.UI;

import javax.imageio.ImageIO;
import javax.swing.*;

import src.model.NotificationStore;
import src.model.PostData;
import src.model.PostStore;
import src.model.SessionStore;
import src.model.User;

import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;

import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.List;

public class HomeFeedUI extends JFrame {
	private static final int WIDTH = 300;
	private static final int HEIGHT = 500;
	private static final int NAV_ICON_SIZE = 20; // Corrected static size for bottom icons
	private static final int IMAGE_WIDTH = WIDTH - 100; // Width for the image posts
	private static final int IMAGE_HEIGHT = 150; // Height for the image posts
	private static final Color LIKE_BUTTON_COLOR = new Color(255, 90, 95); // Color for the like button
	private CardLayout cardLayout;
	private JPanel cardPanel;
	private JPanel homePanel;
	private JPanel imageViewPanel;
	private final SessionStore sessionStore = new SessionStore();
	private final NotificationStore interactionStore = new NotificationStore();
	private final PostStore postStore = new PostStore();

	public HomeFeedUI() {
		setTitle("Quakstagram Home 3");
		setSize(WIDTH, HEIGHT);
		setMinimumSize(new Dimension(WIDTH, HEIGHT));
		setDefaultCloseOperation(EXIT_ON_CLOSE);
		setLayout(new BorderLayout());
		cardLayout = new CardLayout();
		cardPanel = new JPanel(cardLayout);

		homePanel = new JPanel(new BorderLayout());
		imageViewPanel = new JPanel(new BorderLayout());

		initializeUI();

		cardPanel.add(homePanel, "Home");
		cardPanel.add(imageViewPanel, "ImageView");

		add(cardPanel, BorderLayout.CENTER);
		cardLayout.show(cardPanel, "Home"); // Start with the home view

		// Header Panel (reuse from InstagramProfileUI or customize for home page)
		// Header with the Register label
		JPanel headerPanel = new JPanel(new FlowLayout(FlowLayout.CENTER));
		headerPanel.setBackground(new Color(51, 51, 51)); // Set a darker background for the header
		JLabel lblRegister = new JLabel("🐥 Quackstagram 🐥");
		lblRegister.setFont(new Font("Arial", Font.BOLD, 16));
		lblRegister.setForeground(Color.WHITE); // Set the text color to white
		headerPanel.add(lblRegister);
		headerPanel.setPreferredSize(new Dimension(WIDTH, 40)); // Give the header a fixed height

		add(headerPanel, BorderLayout.NORTH);

		// Navigation Bar
		JPanel navigationPanel = new JPanel();
		navigationPanel.setBackground(new Color(249, 249, 249));
		navigationPanel.setLayout(new BoxLayout(navigationPanel, BoxLayout.X_AXIS));
		navigationPanel.setBorder(BorderFactory.createEmptyBorder(5, 5, 5, 5));

		navigationPanel.add(createIconButton("img/icons/home.png", "home"));
		navigationPanel.add(Box.createHorizontalGlue());
		navigationPanel.add(createIconButton("img/icons/search.png", "explore"));
		navigationPanel.add(Box.createHorizontalGlue());
		navigationPanel.add(createIconButton("img/icons/add.png", "add"));
		navigationPanel.add(Box.createHorizontalGlue());
		navigationPanel.add(createIconButton("img/icons/heart.png", "notification"));
		navigationPanel.add(Box.createHorizontalGlue());
		navigationPanel.add(createIconButton("img/icons/profile.png", "profile"));

		add(navigationPanel, BorderLayout.SOUTH);
	}

	private void initializeUI() {

		// Content Scroll Panel
		JPanel contentPanel = new JPanel();
		contentPanel.setLayout(new BoxLayout(contentPanel, BoxLayout.Y_AXIS)); // Vertical box layout
		JScrollPane scrollPane = new JScrollPane(contentPanel);
		scrollPane.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER); // Never allow
																									// horizontal
																									// scrolling
		String[][] sampleData = createSampleData();
		populateContentPanel(contentPanel, sampleData);
		add(scrollPane, BorderLayout.CENTER);

		// Set up the home panel

		contentPanel.setLayout(new BoxLayout(contentPanel, BoxLayout.Y_AXIS));

		homePanel.add(scrollPane, BorderLayout.CENTER);

	}

	private void populateContentPanel(JPanel panel, String[][] sampleData) {

		for (String[] postData : sampleData) {
			JPanel itemPanel = new JPanel();
			itemPanel.setLayout(new BoxLayout(itemPanel, BoxLayout.Y_AXIS));
			itemPanel.setBackground(Color.WHITE); // Set the background color for the item panel
			itemPanel.setBorder(BorderFactory.createEmptyBorder(5, 5, 5, 5));
			itemPanel.setAlignmentX(CENTER_ALIGNMENT);
			JLabel nameLabel = new JLabel(postData[0]);
			nameLabel.setAlignmentX(Component.LEFT_ALIGNMENT);

			// g

			// Crop the image to the fixed size
			JLabel imageLabel = new JLabel();
			imageLabel.setAlignmentX(Component.LEFT_ALIGNMENT);
			imageLabel.setPreferredSize(new Dimension(IMAGE_WIDTH, IMAGE_HEIGHT));
			imageLabel.setBorder(BorderFactory.createLineBorder(Color.BLACK)); // Add border to image label
			String imageId = new File(postData[3]).getName().split("\\.")[0];

			try {
				BufferedImage originalImage = ImageIO.read(new File(postData[3]));
				Image iconScaled = originalImage.getScaledInstance(IMAGE_WIDTH,IMAGE_HEIGHT,Image.SCALE_SMOOTH);
				ImageIcon imageIcon = new ImageIcon(iconScaled);
				imageLabel.setIcon(imageIcon);
			} catch (IOException ex) {
				// Handle exception: Image file not found or reading error
				imageLabel.setText("Image not found");
				ex.printStackTrace();
			}

			JLabel descriptionLabel = new JLabel(postData[1]);
			descriptionLabel.setAlignmentX(Component.LEFT_ALIGNMENT);

			JLabel likesLabel = new JLabel(postData[2]);
			likesLabel.setAlignmentX(Component.LEFT_ALIGNMENT);

			JButton likeButton = new JButton("❤");
			likeButton.setAlignmentX(Component.LEFT_ALIGNMENT);
			likeButton.setBackground(LIKE_BUTTON_COLOR); // Set the background color for the like button
			likeButton.setOpaque(true);
			likeButton.setBorderPainted(false); // Remove border
			likeButton.addActionListener(new ActionListener() {
				@Override
				public void actionPerformed(ActionEvent e) {
					handleLikeAction(imageId, likesLabel);
				}
			});

			itemPanel.add(nameLabel);
			itemPanel.add(imageLabel);
			itemPanel.add(descriptionLabel);
			itemPanel.add(likesLabel);
			itemPanel.add(likeButton);

			panel.add(itemPanel);

			// Make the image clickable
			imageLabel.addMouseListener(new MouseAdapter() {
				@Override
				public void mouseClicked(MouseEvent e) {
					displayImage(postData); // Call a method to switch to the image view
				}
			});

			// Grey spacing panel
			JPanel spacingPanel = new JPanel();
			spacingPanel.setPreferredSize(new Dimension(WIDTH - 10, 5)); // Set the height for spacing
			spacingPanel.setBackground(new Color(230, 230, 230)); // Grey color for spacing
			panel.add(spacingPanel);
		}
	}

	private void handleLikeAction(String imageId, JLabel likesLabel) {
		String currentUser = sessionStore.getLoggedInUsername();
		PostStore.LikeResult result = postStore.likePost(imageId, currentUser);
		if (result != null) {
			likesLabel.setText("Likes: " + result.getLikesCount());
			if (result.isNewLike()) {
				interactionStore.addNotification(result.getImageOwner(), currentUser, result.getPostId());
			}
		}
	}

	private String[][] createSampleData() {
		String currentUser = sessionStore.getLoggedInUsername();
		List<PostData> posts = postStore.findFeedPosts(currentUser);
		String[][] sampleData = new String[posts.size()][];
		for (int i = 0; i < posts.size(); i++) {
			PostData post = posts.get(i);
			sampleData[i] = new String[] {
					post.getUsername(),
					post.getCaption(),
					"Likes: " + post.getLikesCount(),
					post.getImagePath()
			};
		}
		return sampleData;
	}

	private void displayImage(String[] postData) {
		imageViewPanel.removeAll(); // Clear previous content

		String imageId = new File(postData[3]).getName().split("\\.")[0];
		JLabel likesLabel = new JLabel(postData[2]); // Update this line

		// Display the image
		JLabel fullSizeImageLabel = new JLabel();
		fullSizeImageLabel.setHorizontalAlignment(JLabel.CENTER);

		try {
			BufferedImage originalImage = ImageIO.read(new File(postData[3]));
			// Dynamically resizes the image when the components resizes. Could be done
			// better, but this is the Quack way.
			fullSizeImageLabel.addComponentListener(new ComponentAdapter() {
				@Override
				public void componentResized(ComponentEvent e) {
					int w = fullSizeImageLabel.getWidth();
					int h = fullSizeImageLabel.getHeight();

					double scale = Math.min(
							(double) w / originalImage.getWidth(),
							(double) h / originalImage.getHeight());

					int newW = (int) (originalImage.getWidth() * scale);
					int newH = (int) (originalImage.getHeight() * scale);

					Image scaled = originalImage.getScaledInstance(newW, newH, Image.SCALE_SMOOTH);
					fullSizeImageLabel.setIcon(new ImageIcon(scaled));
				}
			});
		} catch (IOException ex) {
			// Handle exception: Image file not found or reading error
			fullSizeImageLabel.setText("Image not found");
		}

		// User Info
		JPanel userPanel = new JPanel();
		userPanel.setLayout(new BoxLayout(userPanel, BoxLayout.Y_AXIS));
		JLabel userName = new JLabel(postData[0]);
		userName.setFont(new Font("Arial", Font.BOLD, 18));
		userPanel.add(userName);// User Name

		JButton likeButton = new JButton("❤");
		likeButton.setAlignmentX(Component.LEFT_ALIGNMENT);
		likeButton.setBackground(LIKE_BUTTON_COLOR); // Set the background color for the like button
		likeButton.setOpaque(true);
		likeButton.setBorderPainted(false); // Remove border
		likeButton.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				handleLikeAction(imageId, likesLabel); // Update this line
				refreshDisplayImage(postData, imageId); // Refresh the view
			}
		});

		// Information panel at the bottom
		JPanel infoPanel = new JPanel();
		infoPanel.setLayout(new BoxLayout(infoPanel, BoxLayout.Y_AXIS));
		infoPanel.add(new JLabel(postData[1])); // Description
		infoPanel.add(new JLabel(postData[2])); // Likes
		infoPanel.add(likeButton);

		imageViewPanel.add(fullSizeImageLabel, BorderLayout.CENTER);
		imageViewPanel.add(infoPanel, BorderLayout.SOUTH);
		imageViewPanel.add(userPanel, BorderLayout.NORTH);

		imageViewPanel.revalidate();
		imageViewPanel.repaint();

		cardLayout.show(cardPanel, "ImageView"); // Switch to the image view
	}

	private void refreshDisplayImage(String[] postData, String imageId) {
		PostData post = postStore.findPostByImageId(imageId);
		if (post != null) {
			postData[2] = "Likes: " + post.getLikesCount();
		}

		// Call displayImage with updated postData
		displayImage(postData);
	}

	private JButton createIconButton(String iconPath, String buttonType) {
		ImageIcon iconOriginal = new ImageIcon(iconPath);
		Image iconScaled = iconOriginal.getImage().getScaledInstance(NAV_ICON_SIZE, NAV_ICON_SIZE, Image.SCALE_SMOOTH);
		JButton button = new JButton(new ImageIcon(iconScaled));
		button.setBorder(BorderFactory.createEmptyBorder());
		button.setContentAreaFilled(false);

		// Define actions based on button type
		if ("home".equals(buttonType)) {
			button.addActionListener(e -> openHomeUI());
		} else if ("profile".equals(buttonType)) {
			button.addActionListener(e -> openProfileUI());
		} else if ("notification".equals(buttonType)) {
			button.addActionListener(e -> notificationsUI());
		} else if ("explore".equals(buttonType)) {
			button.addActionListener(e -> exploreUI());
		} else if ("add".equals(buttonType)) {
			button.addActionListener(e -> ImageUploadUI());
		}
		return button;

	}

	private void openProfileUI() {
		this.dispose();

		String loggedInUsername = sessionStore.getLoggedInUsername();
		User user = new User(loggedInUsername);

		QuackstagramProfileUI profileUI = new QuackstagramProfileUI(user);
		profileUI.setVisible(true);
	}

	private void notificationsUI() {
		// Open InstagramProfileUI frame
		this.dispose();
		NotificationsUI notificationsUI = new NotificationsUI();
		notificationsUI.setVisible(true);
	}

	private void ImageUploadUI() {
		// Open InstagramProfileUI frame
		this.dispose();
		ImageUploadUI upload = new ImageUploadUI();
		upload.setVisible(true);
	}

	private void openHomeUI() {
		// Open InstagramProfileUI frame
		this.dispose();
		HomeFeedUI homeUI = new HomeFeedUI();
		homeUI.setVisible(true);
	}

	private void exploreUI() {
		// Open InstagramProfileUI frame
		this.dispose();
		ExploreUI explore = new ExploreUI();
		explore.setVisible(true);
	}

}
