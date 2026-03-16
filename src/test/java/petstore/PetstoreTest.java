package petstore;

import com.aventstack.extentreports.ExtentReports;
import com.aventstack.extentreports.ExtentTest;
import com.aventstack.extentreports.Status;
import com.aventstack.extentreports.reporter.ExtentSparkReporter;
import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * Karate test runner with Extent Report integration.
 * Runs all .feature files and generates a visual HTML report.
 */
public class PetstoreTest {

    private static ExtentReports extent;
    private static Results results;

    @BeforeAll
    static void setupReport() {
        // Configure Extent Spark Reporter
        ExtentSparkReporter sparkReporter = new ExtentSparkReporter("target/extent-report.html");
        sparkReporter.config().setDocumentTitle("Petstore API Test Report");
        sparkReporter.config().setReportName("Karate BDD — Petstore API");
        sparkReporter.config().setTheme(com.aventstack.extentreports.reporter.configuration.Theme.DARK);

        extent = new ExtentReports();
        extent.attachReporter(sparkReporter);
        extent.setSystemInfo("Project", "Petstore Karate BDD");
        extent.setSystemInfo("API Base URL", "https://petstore.swagger.io/v2");
        extent.setSystemInfo("Framework", "Karate DSL 1.4.1");
        extent.setSystemInfo("Author", "QA Intern — VakıfBank");
    }

    @Test
    void testAllFeatures() {
        // Run all .feature files in 'petstore' package
        results = Runner.path("classpath:petstore")
                .parallel(1);

        // Generate Extent Report entries from Karate results
        generateExtentReport(results);

        // Assert all scenarios passed
        assertEquals(0, results.getFailCount(),
                "There are failed scenarios! Check the Extent Report at target/extent-report.html");
    }

    private void generateExtentReport(Results results) {
        // Create test entries for each feature result
        results.getScenarioResults().forEach(scenarioResult -> {
            String featureName = scenarioResult.getScenario().getFeature().getName();
            String scenarioName = scenarioResult.getScenario().getName();

            ExtentTest featureTest = extent.createTest(featureName + " — " + scenarioName);

            if (scenarioResult.isFailed()) {
                featureTest.log(Status.FAIL, "Scenario FAILED");
                featureTest.log(Status.FAIL, scenarioResult.getErrorMessage());
            } else {
                featureTest.log(Status.PASS, "Scenario PASSED");
            }

            // Log step details
            scenarioResult.getStepResults().forEach(step -> {
                String stepText = step.getStep().getText();
                if (step.isFailed()) {
                    featureTest.log(Status.FAIL, "STEP FAILED: " + stepText);
                    if (step.getErrorMessage() != null) {
                        featureTest.log(Status.INFO, step.getErrorMessage());
                    }
                } else {
                    featureTest.log(Status.PASS, "STEP: " + stepText);
                }
            });
        });
    }

    @AfterAll
    static void tearDown() {
        if (extent != null) {
            extent.flush();
            System.out.println("========================================");
            System.out.println("  Extent Report generated at:");
            System.out.println("  target/extent-report.html");
            System.out.println("========================================");
        }
    }
}
